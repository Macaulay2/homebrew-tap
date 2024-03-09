class Factory < Formula
  desc "C++ class library for recursive representation of multivariate polynomial data"
  homepage "https://github.com/Singular/Singular/blob/spielwiese/factory/README"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Factory/factory-4.3.0.tar.gz"
  version "4.3.2p15-151235c5"
  sha256 "f1e25b566a8c06d0e98b9795741c6d12b5a34c5c0c61c078d9346d8bbc82f09f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/factory-4.3.2p15-151235c5"
    sha256 cellar: :any,                 arm64_sonoma: "5538821c3de4448cbd611c455d6998a6d4cf369a08e3f768a6023b4543ec5232"
    sha256 cellar: :any,                 ventura:      "3e26fbf58ec2ffba6ce6815af6c6550ccf558eaabf251c68b2dc3084eabd0340"
    sha256 cellar: :any,                 monterey:     "c4df36b218a2bec51d6b31eeb4036938dea17f89e80a8993b33164350a480565"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a84086efe8d46fb227e03a813051b8f3d3ab33a893d84e931fabc10c38b5e93b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "ntl"

  # diff of Release-4-3-0..151235c5
  patch :DATA

  def install
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-doxygen-doc
      --disable-silent-rules
      --disable-omalloc
      --without-Singular
      --with-gmp=#{Formula["gmp"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --with-flint=#{Formula["flint"].prefix}
      --prefix=#{prefix}
      CXXFLAGS=-std=c++11
    ]
    system "autoreconf", "-vif"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # also check:
    #  grep [[^.define HAVE_NTL 1]] _config.h
    #  grep [[^.define HAVE_FLINT 1]] _config.h
    (testpath/"test.cc").write <<-EOS
        #include "factory/factory.h"

        int main()
        {
	  Off (SW_USE_EZGCD);
	  Off (SW_USE_CHINREM_GCD);

          int p = 101;
	  int ret = 0;
	  setCharacteristic (p);
	  CanonicalForm d1= Variable (1) + Variable (2) + 1;
	  CanonicalForm f1= Variable (1) - Variable (2) - 2;
	  CanonicalForm g1= Variable (1) + Variable (2) + 2;
	  CanonicalForm d= power (d1, 2);
	  CanonicalForm f= d* power (f1, 2);
	  CanonicalForm g= d* power (g1, 2);
	  CanonicalForm h= gcd (f,g);
	  h /= Lc (h);
	  if (h != d)
	    ret = -1;
	  for (int i= 3; i <= 7; i++)
	    {
	      d1 += power (Variable (i), i);
	      f1 -= power (Variable (i), i);
	      g1 += power (Variable (i), i);
	      d= power (d1, 2);
	      f= d*power (f1, 2);
	      g= d*power (g1, 2);
	      h= gcd (f,g);
	      h /= Lc (h);
	      if (h != d)
		ret = -1;
	    }
	  return ret;
	}
    EOS
    system ENV.cxx, "test.cc", "-I#{include}", "-L#{lib}", "-lfactory",
           "-L#{Formula["flint"].lib}", "-lflint",
           "-L#{Formula["ntl"].lib}", "-lntl",
           "-L#{Formula["gmp"].lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end

__END__

diff --git a/COPYING b/COPYING
index 142252eef..6f77e94bf 100644
--- a/COPYING
+++ b/COPYING
@@ -7,7 +7,7 @@
 
   Authors: G.-M. Greuel, R. Stobbe, J. Schmidt, M. Lee,
                     G. Pfister, H. Schoenemann
-                        Copyright (C) 1991-2022
+                        Copyright (C) 1991-2023
 
   Characteristic sets and factorization over algebraic function fields:
                    Michael Messollen <mmessollen@web.de>
diff --git a/FLINTconvert.cc b/FLINTconvert.cc
index d103d3f36..ac5f8dcbb 100644
--- a/FLINTconvert.cc
+++ b/FLINTconvert.cc
@@ -15,6 +15,7 @@
 
 #include <config.h>
 
+#include <string.h>
 
 #include "canonicalform.h"
 #include "fac_util.h"
@@ -62,6 +63,7 @@ extern "C"
 #endif
 #if ( __FLINT_RELEASE >= 20503)
 #include <flint/fmpq_mpoly.h>
+#include <flint/fmpz_mod.h>
 
 // planed, but not yet in FLINT:
 #if (__FLINT_RELEASE < 20700)
@@ -85,7 +87,7 @@ void fq_nmod_set_nmod_poly(fq_nmod_t a, const nmod_poly_t b, const fq_nmod_ctx_t
     nmod_poly_set(a, b);
     fq_nmod_reduce(a, ctx);
 }
-#else
+#elif  (__FLINT_RELEASE < 30000)
 void fq_nmod_set_nmod_poly(fq_nmod_t a, const nmod_poly_t b,
                                                        const fq_nmod_ctx_t ctx)
 {
diff --git a/FLINTconvert.h b/FLINTconvert.h
index bed483b97..3908d77fc 100644
--- a/FLINTconvert.h
+++ b/FLINTconvert.h
@@ -45,6 +45,12 @@ extern "C"
 #endif
 #if ( __FLINT_RELEASE >= 20700)
 #include <flint/fq_nmod_mpoly_factor.h>
+#include <flint/fmpz_mod.h>
+#endif
+#if ( __FLINT_RELEASE >= 30000)
+#include <flint/nmod.h>
+#include <flint/nmod_mpoly.h>
+#include <flint/fmpz_vec.h>
 #endif
 #endif
 
diff --git a/NTLconvert.cc b/NTLconvert.cc
index 6dec6be89..eedb70b67 100644
--- a/NTLconvert.cc
+++ b/NTLconvert.cc
@@ -43,7 +43,7 @@
 void out_cf(const char *s1,const CanonicalForm &f,const char *s2);
 
 
-VAR long fac_NTL_char = -1;         // the current characterstic for NTL calls
+VAR long fac_NTL_char = -1;         // the current characteristic for NTL calls
                                 // -1: undefined
 #ifdef NTL_CLIENT               // in <NTL/tools.h>: using of name space NTL
 NTL_CLIENT
diff --git a/README b/README
index 440791c14..5cd808206 100644
--- a/README
+++ b/README
@@ -204,7 +204,7 @@ example applications for Factory.
 =================================
 Algorithms for manipulation of polynomial ideals via the characteristic set
 methods (e.g., calculating the characteristic set and the irreducible
-characteristic series) are now incorpareted into factory.
+characteristic series) are now incorporated into factory.
 If you want to learn about characteristic sets, the next is a good point
 to start with:
     Dongming Wang:
diff --git a/cfModGcd.cc b/cfModGcd.cc
index 435a66336..482f55898 100644
--- a/cfModGcd.cc
+++ b/cfModGcd.cc
@@ -22,6 +22,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "debug.h"
@@ -1805,7 +1806,11 @@ gaussianElimFq (CFMatrix& M, CFArray& L, const Variable& alpha)
   fq_nmod_mat_t FLINTN;
   convertFacCFMatrix2Fq_nmod_mat_t (FLINTN, ctx, *N);
   // rank
+  #if __FLINT_RELEASE >= 30100
+  long rk= fq_nmod_mat_rref (FLINTN,FLINTN,ctx);
+  #else
   long rk= fq_nmod_mat_rref (FLINTN,ctx);
+  #endif
   // clean up
   fq_nmod_mat_clear (FLINTN,ctx);
   fq_nmod_ctx_clear(ctx);
@@ -1825,7 +1830,6 @@ gaussianElimFq (CFMatrix& M, CFArray& L, const Variable& alpha)
   #else
   factoryError("NTL/FLINT missing: gaussianElimFq");
   #endif
-  delete N;
 
   M= (*N) (1, M.rows(), 1, M.columns());
   L= CFArray (M.rows());
@@ -1912,7 +1916,11 @@ solveSystemFq (const CFMatrix& M, const CFArray& L, const Variable& alpha)
   fq_nmod_mat_t FLINTN;
   convertFacCFMatrix2Fq_nmod_mat_t (FLINTN, ctx, *N);
   // rank
+  #if __FLINT_RELEASE >= 30100
+  long rk= fq_nmod_mat_rref (FLINTN,FLINTN,ctx);
+  #else
   long rk= fq_nmod_mat_rref (FLINTN,ctx);
+  #endif
   #elif defined(HAVE_NTL)
   int p= getCharacteristic ();
   if (fac_NTL_char != p)
diff --git a/cfModResultant.cc b/cfModResultant.cc
index 601a15394..c1060b612 100644
--- a/cfModResultant.cc
+++ b/cfModResultant.cc
@@ -13,6 +13,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "timing.h"
diff --git a/cf_factor.cc b/cf_factor.cc
index 6b240994b..0e937c5d6 100644
--- a/cf_factor.cc
+++ b/cf_factor.cc
@@ -47,6 +47,10 @@
 #include <flint/nmod_mpoly_factor.h>
 #include <flint/fmpq_mpoly_factor.h>
 #include <flint/fq_nmod_mpoly_factor.h>
+#include <flint/nmod_poly_factor.h>
+#include <flint/fmpz_poly_factor.h>
+#include <flint/fmpz_mpoly_factor.h>
+#include <flint/fq_nmod_poly_factor.h>
 #endif
 #endif
 
diff --git a/cf_map_ext.cc b/cf_map_ext.cc
index e735a9a87..2b0388fc9 100644
--- a/cf_map_ext.cc
+++ b/cf_map_ext.cc
@@ -30,6 +30,7 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include <flint/fq_nmod_poly_factor.h>
 #endif
 
 // cyclotomoic polys:
diff --git a/cf_ops.cc b/cf_ops.cc
index a9513938d..28b76ac19 100644
--- a/cf_ops.cc
+++ b/cf_ops.cc
@@ -394,7 +394,7 @@ getVars ( const CanonicalForm & f )
       if ( i > 0 ) i--;
    }
 ~~~~~~~~~~~~~~~~~~~~~
- * Then apply( f, diff ) is differentation of f with respect to the
+ * Then apply( f, diff ) is differentiation of f with respect to the
  * main variable of f.
  *
 **/
diff --git a/cf_roots.cc b/cf_roots.cc
index fb627ce60..b57038263 100644
--- a/cf_roots.cc
+++ b/cf_roots.cc
@@ -18,6 +18,7 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include "flint/nmod_poly_factor.h"
 #endif
 
 #include "cf_roots.h"
diff --git a/configure.ac b/configure.ac
index dd5ab8d24..72d5b426b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,11 +12,11 @@ dnl #
 #
 # - initialisation.
 #
-AC_INIT([factory], [4.3.0])
+AC_INIT([factory], [4.3.2])
 AC_CONFIG_SRCDIR(canonicalform.cc)
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_AUX_DIR([.])
-AC_CONFIG_HEADER([_config.h])
+AC_CONFIG_HEADERS([_config.h])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects]) # -Wno-extra-portability -Werror silent-rules
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
diff --git a/facAbsBiFact.cc b/facAbsBiFact.cc
index 32ce09602..717e76ed9 100644
--- a/facAbsBiFact.cc
+++ b/facAbsBiFact.cc
@@ -23,6 +23,7 @@
 #include "cf_algorithm.h"
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include "flint/nmod_poly_factor.h"
 #include <flint/fmpz_poly_factor.h>
 #endif
 #ifdef HAVE_NTL
diff --git a/facAlgFunc.cc b/facAlgFunc.cc
index 6d745556f..b3f6b4b12 100644
--- a/facAlgFunc.cc
+++ b/facAlgFunc.cc
@@ -763,7 +763,7 @@ SteelTrager (const CanonicalForm & f, const CFList & AS)
   CFListIterator i, ii;
 
   bool derivZeroF= false;
-  int j, expF= 0, tmpExp;
+  int j, expF=0, tmpExp=0;
   CFFList varsMapLevel, tmp;
   CFFListIterator iter;
 
diff --git a/facBivar.cc b/facBivar.cc
index 43b065a17..bd088958e 100644
--- a/facBivar.cc
+++ b/facBivar.cc
@@ -329,7 +329,7 @@ CFList biFactorize (const CanonicalForm& F, const Variable& v)
   int subCheck1= substituteCheck (A, x);
   int subCheck2= substituteCheck (A, y);
   buf= swapvar (A,x,y);
-  int evaluation, evaluation2, bufEvaluation= 0, bufEvaluation2= 0;
+  int evaluation, evaluation2=0, bufEvaluation= 0, bufEvaluation2= 0;
   for (int i= 0; i < factorNums; i++)
   {
     bufAeval= A;
diff --git a/facFqBivar.cc b/facFqBivar.cc
index 0d4429c53..7d3ae8438 100644
--- a/facFqBivar.cc
+++ b/facFqBivar.cc
@@ -19,6 +19,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "cf_util.h"
@@ -43,6 +44,8 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include "flint/nmod_poly_factor.h"
+#include "flint/fq_nmod_poly_factor.h"
 #endif
 
 TIMING_DEFINE_PRINT(fac_fq_uni_factorizer)
diff --git a/facFqBivarUtil.cc b/facFqBivarUtil.cc
index c2bf04fe0..8cc7675ad 100644
--- a/facFqBivarUtil.cc
+++ b/facFqBivarUtil.cc
@@ -229,7 +229,7 @@ void appendTestMapDown (CFList& factors, const CanonicalForm& f,
   CanonicalForm delta= info.getDelta();
   CanonicalForm gamma= info.getGamma();
   CanonicalForm g= f;
-  int degMipoBeta;
+  int degMipoBeta=0;
   if (!k && beta.level() == 1)
     degMipoBeta= 1;
   else if (!k && beta.level() != 1)
diff --git a/facFqFactorize.cc b/facFqFactorize.cc
index 6b35b6409..6cb91fd53 100644
--- a/facFqFactorize.cc
+++ b/facFqFactorize.cc
@@ -18,6 +18,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "debug.h"
diff --git a/facMul.cc b/facMul.cc
index 1b734f701..08d09ccdf 100644
--- a/facMul.cc
+++ b/facMul.cc
@@ -22,6 +22,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "canonicalform.h"
 #include "facMul.h"
@@ -37,6 +38,10 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include "flint/fq_nmod_vec.h"
+#if __FLINT_RELEASE >= 20503
+#include "flint/fmpz_mod.h"
+#endif
 #endif
 
 // univariate polys
diff --git a/gfops.cc b/gfops.cc
index f231a9bba..4538c4746 100644
--- a/gfops.cc
+++ b/gfops.cc
@@ -92,7 +92,7 @@ static void gf_get_table ( int p, int n )
     FILE * inputfile;
     if (gftable_dir)
     {
-      sprintf( buffer, "gftables/%d", q);
+      snprintf( buffer, gf_maxbuffer, "gftables/%d", q);
       gffilename = (char *)malloc(strlen(gftable_dir) + strlen(buffer) + 1);
       STICKYASSERT(gffilename,"out of memory");
       strcpy(gffilename,gftable_dir);
@@ -101,7 +101,7 @@ static void gf_get_table ( int p, int n )
     }
     else
     {
-      sprintf( buffer, "gftables/%d", q );
+      snprintf( buffer, gf_maxbuffer, "gftables/%d", q );
       gffilename = buffer;
 #ifndef SINGULAR
       inputfile = fopen( buffer, "r" );
diff --git a/int_poly.cc b/int_poly.cc
index 9bf191b23..195d13703 100644
--- a/int_poly.cc
+++ b/int_poly.cc
@@ -999,21 +999,23 @@ InternalPoly::comparesame ( InternalCF * acoeff )
         termList cursor1 = firstTerm;
         termList cursor2 = apoly->firstTerm;
         for ( ; cursor1 && cursor2; cursor1 = cursor1->next, cursor2 = cursor2->next )
+        {
             // we test on inequality of coefficients at this
             // point instead of testing on "less than" at the
             // last `else' in the enclosed `if' statement since a
-            // test on inequaltiy in general is cheaper
-            if ( (cursor1->exp != cursor2->exp) || (cursor1->coeff != cursor2->coeff) )
-            {
-                if ( cursor1->exp > cursor2->exp )
-                    return 1;
-                else  if ( cursor1->exp < cursor2->exp )
-                    return -1;
-                else  if ( cursor1->coeff > cursor2->coeff )
+            // test on inequality in general is cheaper
+            if ( cursor1->exp > cursor2->exp )
+                return 1;
+            else  if ( cursor1->exp < cursor2->exp )
+                return -1;
+            if ( (cursor1->coeff != cursor2->coeff) )
+            {
+                if ( cursor1->coeff > cursor2->coeff )
                     return 1;
                 else
                     return -1;
-             }
+            }
+        }
         // check trailing terms
         if ( cursor1 == cursor2 )
             return 0;
