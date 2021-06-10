class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/Macaulay2/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 7

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fflas-ffpack-2.4.3_7"
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "723ae5993b9518077654be6ae71498861e640c09b5522b079c21ef5c57f0bda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "889d640146a8abc7271780bfc0a8d36778e9f2060031f1e75c672b4bc862e193"
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
  depends_on "openblas" unless OS.mac?

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
