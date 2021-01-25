class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/Macaulay2/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 6

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fflas-ffpack-2.4.3_5"
    cellar :any_skip_relocation
    sha256 "38d6310fc65eac930289d17f68f4454850910e7595376830dd8407894868a2fb" => :catalina
    sha256 "59233257c1dcf9ab98b7cbb862d8cba7fee19819ee0ca634521d2a93a746af05" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/fflas-ffpack.git", using: :git
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "openblas@0.3.13" unless OS.mac?

  # See https://github.com/linbox-team/fflas-ffpack/issues/309
  patch :DATA

  def install
    ENV.cxx11
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OMPFLAGS"] = "-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    else
      ENV["OMPFLAGS"] = "-fopenmp"
    end
    ENV["CBLAS_LIBS"] = ENV["LIBS"] = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "./autogen.sh",
           "--enable-openmp",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end

__END__
diff --git a/macros/omp-check.m4 b/macros/omp-check.m4
index 01c5fdac..0d407e1c 100644
--- a/macros/omp-check.m4
+++ b/macros/omp-check.m4
@@ -36,7 +36,6 @@ AC_DEFUN([FF_CHECK_OMP],
 	  AS_IF([ test "x$avec_omp" != "xno" ],
 		[
 		BACKUP_CXXFLAGS=${CXXFLAGS}
-		OMPFLAGS="-fopenmp"
 		CXXFLAGS="${BACKUP_CXXFLAGS} ${OMPFLAGS}"
 		AC_TRY_RUN([
 #include <omp.h>
-- 
2.26.2
