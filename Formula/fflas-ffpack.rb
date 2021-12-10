class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/Macaulay2/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 8

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fflas-ffpack-2.4.3_8"
    sha256 cellar: :any_skip_relocation, big_sur:      "bf7db10872cadfaa0716b1f6474b81347b18cd97992fe61568c78ff39974c536"
    sha256 cellar: :any_skip_relocation, catalina:     "d1b66b4052e32175b7dd842723962f6694bee4734f8c33bca24e9ef6f98fbbc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "82cd7cd560c8c1522d66c5d4363ef20e546e67f17d2599657a02b6cab1ca77a5"
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
