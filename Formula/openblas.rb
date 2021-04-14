class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.13.tar.gz"
  sha256 "79197543b17cc314b7e43f7a33148c308b0807cd6381ee77f77e15acf3e6459e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/xianyi/OpenBLAS.git", branch: "develop"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/openblas-0.3.13_1"
    sha256 cellar: :any, catalina:     "a2bdb5cdf0fb13e5629d38473d61c57555debb3d6c5e88a6e4b7db0e2640de35"
    sha256 cellar: :any, x86_64_linux: "5cb0cda041379272f30a43b0614b94e55f547ad8ff269daac4d7a3d787606780"
  end

  keg_only :shadowed_by_macos, "macOS provides BLAS in Accelerate.framework"

  depends_on "gcc@9" # for gfortran
  fails_with :clang

  # Build script fix. Remove at version bump.
  # https://github.com/xianyi/OpenBLAS/pull/3038
  patch do
    url "https://github.com/xianyi/OpenBLAS/commit/00ce35336ee1eb1089f30d1e117a8a6a933f9654.patch?full_index=1"
    sha256 "555e3a8ab042bef2320549db2bad57249d9cf351a6f28e82d6ba53f008920465"
  end

  def install
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    ENV["NO_AVX512"] = "1"
    # Force a large NUM_THREADS to support larger Macs than the VMs that build the bottles
    ENV["NUM_THREADS"] = "56"
    ENV["TARGET"] = case Hardware.oldest_cpu
    when :arm_vortex_tempest
      "VORTEX"
    else
      Hardware.oldest_cpu.upcase.to_s
    end

    # Must call in two steps
    gcc = Formula["gcc@9"]
    system "make", "CC=#{gcc.bin}/gcc-9", "FC=#{gcc.bin}/gfortran-9", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink shared_library("libopenblas") => shared_library("libblas")
    lib.install_symlink shared_library("libopenblas") => shared_library("liblapack")
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end
