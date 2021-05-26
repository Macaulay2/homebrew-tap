class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/Macaulay2/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 7

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fflas-ffpack-2.4.3_7"
    sha256 cellar: :any_skip_relocation, catalina:     "d724ede908b1e83b72ffab6c46babc79c2fc78f173aba32ea6bd029f4b29ced8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e3b44ea270aef187b6ce2f3be66fc2e01e52ac617e00d624b04023d3f049fc45"
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
