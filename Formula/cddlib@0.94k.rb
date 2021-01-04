class CddlibAT094k < Formula
  desc "Double description method for general polyhedral cones"
  homepage "https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "https://github.com/cddlib/cddlib/releases/download/0.94k/cddlib-0.94k.tar.gz"
  sha256 "de7397d7fe32758a6b53453a889ec7619b6c68a15d84eb132421f3d7d457be44"
  license "GPL-2.0-only"
  version_scheme 1

  depends_on "gmp"

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
    system ENV.cxx, "test.cpp", "-I#{include}/cddlib", "-L#{lib}", "-lcdd", "-o", "test"
    assert_equal "3.66667", shell_output("./test").split[-1]
  end
end
