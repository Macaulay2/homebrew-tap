class CddlibAT094m < Formula
  desc "Double description method for general polyhedral cones"
  homepage "https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "https://github.com/cddlib/cddlib/releases/download/0.94m/cddlib-0.94m.tar.gz"
  sha256 "70dffdb3369b8704dc75428a1b3c42ab9047b81ce039f12f427e2eb2b1b0dee2"
  license "GPL-2.0-or-later"
  version_scheme 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/cddlib@0.94m-0.94m"
    sha256 cellar: :any,                 big_sur:      "ca8ac58b151eb5955b74ffd98d87ecbe29e189d8a89af5fd16e95cd16fd793e7"
    sha256 cellar: :any,                 catalina:     "237fc359319b8005ccd4d497057cf2f53ce31414b2f68900939b3277e98e16ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2f3d7b23bd3a6bbeea80f4338c0f08d5234eacad0e2f99e616c2de1e436ef0f"
  end

  keg_only :versioned_formula

  if OS.mac?
    depends_on "gcc"
    fails_with :clang
  else
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "setoper.h"
      #include "cdd.h"

      #include <iostream>

      int main(int argc, char *argv[])
      {
        dd_set_global_constants(); /* First, this must be called once to use cddlib. */
        //std::cout << "Welcome to cddlib " << dd_DDVERSION << std::endl;

        dd_ErrorType error=dd_NoError;
        dd_LPSolverType solver;  /* either DualSimplex or CrissCross */
        dd_LPPtr lp;

        dd_rowrange m;
        dd_colrange n;
        dd_NumberType numb;
        dd_MatrixPtr A;
        dd_ErrorType err;

        numb=dd_Real;   /* set a number type */
        m=4;    /* number of rows  */
        n=3;    /* number of columns */
        A=dd_CreateMatrix(m,n);
        dd_set_si2(A->matrix[0][0],4,3); dd_set_si(A->matrix[0][1],-2); dd_set_si(A->matrix[0][2],-1);
        dd_set_si2(A->matrix[1][0],2,3); dd_set_si(A->matrix[1][1], 0); dd_set_si(A->matrix[1][2],-1);
        dd_set_si(A->matrix[2][0],0); dd_set_si(A->matrix[2][1], 1); dd_set_si(A->matrix[2][2], 0);
        dd_set_si(A->matrix[3][0],0); dd_set_si(A->matrix[3][1], 0); dd_set_si(A->matrix[3][2], 1);

        dd_set_si(A->rowvec[0],0);    dd_set_si(A->rowvec[1], 3); dd_set_si(A->rowvec[2], 4);

        A->objective=dd_LPmax;
        lp=dd_Matrix2LP(A, &err); /* load an LP */

        std::cout << std::endl << "--- LP to be solved  ---" << std::endl;
        dd_WriteLP(stdout, lp);

        std::cout << std::endl << "--- Running dd_LPSolve ---" << std::endl;
        solver=dd_DualSimplex;
        dd_LPSolve(lp, solver, &error);  /* Solve the LP */

        //dd_WriteLPResult(stdout, lp, error);

        std::cout << "optimal value:" << std::endl << *lp->optvalue << std::endl;

        dd_FreeLPData(lp);
        dd_FreeMatrix(A);

        dd_free_global_constants();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["cddlib@0.94m"].include}/cddlib", "-L#{Formula["cddlib@0.94m"].lib}",
           "-lcdd", "-o", "test"
    assert_equal "3.66667", shell_output("./test").split[-1]
  end
end

__END__

diff --git a/configure b/configure
index d543a316e3..6f67653a03 100755
--- a/configure
+++ b/configure
@@ -7407,16 +7407,11 @@ $as_echo "$lt_cv_ld_force_load" >&6; }
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[91]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[012][,.]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[012],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*|11.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
-- 
2.31.1