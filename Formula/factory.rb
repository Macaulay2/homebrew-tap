class Factory < Formula
  desc "C++ class library for recursive representation of multivariate polynomial data"
  homepage "https://github.com/Singular/Singular/blob/spielwiese/factory/README"
  # update
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Factory/factory-4.3.0.tar.gz"
  sha256 "f1e25b566a8c06d0e98b9795741c6d12b5a34c5c0c61c078d9346d8bbc82f09f"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/factory-4.3.0_2"
    sha256 cellar: :any,                 ventura:      "9c3f5a9b0e22c5b28a96a51e32a1a5d699245de472c7c601b3eb4916d090502c"
    sha256 cellar: :any,                 monterey:     "be2e9df63de0cdb620fcf39b837cd50a305b97b3a1d4c6fe47af515667e429c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "419125bb7d3dba4dc1e6d0ee3d39a24d7553253454e49f79ef84de0bf57e2960"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
  end

  depends_on "flint"
  depends_on "gmp"
  depends_on "ntl"

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
index 142252eefc..6f77e94bf2 100644
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
index d103d3f36d..0ff904bd7c 100644
--- a/FLINTconvert.cc
+++ b/FLINTconvert.cc
@@ -62,6 +62,7 @@ extern "C"
 #endif
 #if ( __FLINT_RELEASE >= 20503)
 #include <flint/fmpq_mpoly.h>
+#include <flint/fmpz_mod.h>
 
 // planed, but not yet in FLINT:
 #if (__FLINT_RELEASE < 20700)
@@ -1006,7 +1007,7 @@ CanonicalForm gcdFlintMP_QQ(const CanonicalForm& F, const CanonicalForm& G)
 #if __FLINT_RELEASE >= 20700
 CFFList
 convertFLINTFq_nmod_mpoly_factor2FacCFFList (
-                   fq_nmod_mpoly_factor_t fac, 
+                   fq_nmod_mpoly_factor_t fac,
                    const fq_nmod_mpoly_ctx_t& ctx,
                    const int N,
                    const fq_nmod_ctx_t& fq_ctx,
diff --git a/FLINTconvert.h b/FLINTconvert.h
index bed483b973..ec5a56c309 100644
--- a/FLINTconvert.h
+++ b/FLINTconvert.h
@@ -45,6 +45,7 @@ extern "C"
 #endif
 #if ( __FLINT_RELEASE >= 20700)
 #include <flint/fq_nmod_mpoly_factor.h>
+#include <flint/fmpz_mod.h>
 #endif
 #endif
 
@@ -316,7 +317,7 @@ CanonicalForm convFlintMPFactoryP(fmpz_mpoly_t f, fmpz_mpoly_ctx_t ctx, int N);
 #endif // FLINT 2.5.3
 #if __FLINT_RELEASE >= 20700
 CanonicalForm
-convertFq_nmod_mpoly_t2FacCF (const fq_nmod_mpoly_t poly,    ///< [in] 
+convertFq_nmod_mpoly_t2FacCF (const fq_nmod_mpoly_t poly,    ///< [in]
                               const fq_nmod_mpoly_ctx_t& ctx,///< [in] context
                               const int N,                   ///< [in] #vars
                               const fq_nmod_ctx_t& fq_ctx,   ///< [in] fq context
diff --git a/NTLconvert.cc b/NTLconvert.cc
index 6dec6be892..eedb70b673 100644
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
index 440791c146..5cd8082063 100644
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
index 435a663368..12cff69391 100644
--- a/cfModGcd.cc
+++ b/cfModGcd.cc
@@ -22,6 +22,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "debug.h"
diff --git a/cfModResultant.cc b/cfModResultant.cc
index 601a15394a..c1060b6125 100644
--- a/cfModResultant.cc
+++ b/cfModResultant.cc
@@ -13,6 +13,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "timing.h"
diff --git a/cf_factor.cc b/cf_factor.cc
index 6b240994bb..0e937c5d63 100644
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
index e735a9a870..2b0388fc91 100644
--- a/cf_map_ext.cc
+++ b/cf_map_ext.cc
@@ -30,6 +30,7 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include <flint/fq_nmod_poly_factor.h>
 #endif
 
 // cyclotomoic polys:
diff --git a/cf_ops.cc b/cf_ops.cc
index a9513938d8..28b76ac19f 100644
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
index fb627ce609..b57038263b 100644
--- a/cf_roots.cc
+++ b/cf_roots.cc
@@ -18,6 +18,7 @@
 
 #ifdef HAVE_FLINT
 #include "FLINTconvert.h"
+#include "flint/nmod_poly_factor.h"
 #endif
 
 #include "cf_roots.h"
diff --git a/cf_switches.cc b/cf_switches.cc
index d9a36a52d7..f3a3c6d80a 100644
--- a/cf_switches.cc
+++ b/cf_switches.cc
@@ -40,7 +40,7 @@ CFSwitches::CFSwitches ()
 #ifdef HAVE_FLINT
   On(SW_USE_FL_GCD_P);
   On(SW_USE_FL_GCD_0);
-#if (__FLINT_RELEASE >= 20700)  
+#if (__FLINT_RELEASE >= 20700)
   On(SW_USE_FL_FAC_P);
 #endif
 #endif
diff --git a/configure.ac b/configure.ac
index dd5ab8d242..72d5b426bd 100644
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
index 32ce096023..717e76ed99 100644
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
diff --git a/facBivar.cc b/facBivar.cc
index 43b065a171..bd088958e9 100644
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
index 0d4429c530..7d3ae84385 100644
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
@@ -173,7 +176,7 @@ uniFactorizer (const CanonicalForm& A, const Variable& alpha, const bool& GF)
     setCharacteristic (getCharacteristic());
     Variable beta= rootOf (mipo.mapinto());
     CanonicalForm buf= GF2FalphaRep (A, beta);
-#ifdef HAVE_NTL    
+#ifdef HAVE_NTL
     if (getCharacteristic() > 2)
 #else
     if (getCharacteristic() > 0)
@@ -222,7 +225,7 @@ uniFactorizer (const CanonicalForm& A, const Variable& alpha, const bool& GF)
                                                          x, beta);
 #endif
     }
-#ifdef HAVE_NTL    
+#ifdef HAVE_NTL
     else
     {
       GF2X NTLMipo= convertFacCF2NTLGF2X (mipo.mapinto());
@@ -234,7 +237,7 @@ uniFactorizer (const CanonicalForm& A, const Variable& alpha, const bool& GF)
       factorsA= convertNTLvec_pair_GF2EX_long2FacCFFList (NTLFactorsA, multi,
                                                            x, beta);
     }
-#endif    
+#endif
     setCharacteristic (getCharacteristic(), k, cGFName);
     for (CFFListIterator i= factorsA; i.hasItem(); i++)
     {
@@ -246,7 +249,7 @@ uniFactorizer (const CanonicalForm& A, const Variable& alpha, const bool& GF)
   }
   else if (alpha.level() != 1)
   {
-#ifdef HAVE_NTL  
+#ifdef HAVE_NTL
     if (getCharacteristic() > 2)
 #else
     if (getCharacteristic() > 0)
@@ -307,14 +310,14 @@ uniFactorizer (const CanonicalForm& A, const Variable& alpha, const bool& GF)
       factorsA= convertNTLvec_pair_GF2EX_long2FacCFFList (NTLFactorsA, multi,
                                                            x, alpha);
     }
-#endif    
+#endif
   }
   else
   {
 #ifdef HAVE_FLINT
 #ifdef HAVE_NTL
     if (degree (A) < 300)
-#endif    
+#endif
     {
       nmod_poly_t FLINTA;
       convertFacCF2nmod_poly_t (FLINTA, A);
@@ -1501,7 +1504,7 @@ long isReduced (const nmod_mat_t M)
   return 1;
 }
 #endif
-  
+
 #ifdef HAVE_NTL
 long isReduced (const mat_zz_pE& M)
 {
diff --git a/facFqBivarUtil.cc b/facFqBivarUtil.cc
index c2bf04fe04..8cc7675ada 100644
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
index 6b35b64094..6cb91fd532 100644
--- a/facFqFactorize.cc
+++ b/facFqFactorize.cc
@@ -18,6 +18,7 @@
 
 #include "config.h"
 
+#include <math.h>
 
 #include "cf_assert.h"
 #include "debug.h"
diff --git a/facMul.cc b/facMul.cc
index 1b734f701d..08d09ccdf8 100644
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
diff --git a/fac_util.cc b/fac_util.cc
index c9a5c0675a..f6bfac2766 100644
--- a/fac_util.cc
+++ b/fac_util.cc
@@ -177,7 +177,7 @@ CanonicalForm
 prod ( const CFArray & a )
 {
     return prod( a, a.min(), a.max() );
-}   
+}
 
 void
 extgcd ( const CanonicalForm & a, const CanonicalForm & b, CanonicalForm & S, CanonicalForm & T, const modpk & pk )
diff --git a/int_poly.cc b/int_poly.cc
index 9bf191b23b..195d137033 100644
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
