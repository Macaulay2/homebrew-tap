class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/linbox-team/fflas-ffpack/releases/download/v2.5.0/fflas-ffpack-2.5.0.tar.gz"
  sha256 "dafb4c0835824d28e4f823748579be6e4c8889c9570c6ce9cce1e186c3ebbb23"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fflas-ffpack-2.5.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09243154036963bfe61d886796bafca1b124412a573ae8cc07c881aa2eb76d32"
    sha256 cellar: :any_skip_relocation, big_sur:        "77cb085376d5e5f5ca967cbc804a4e02e2858b002faf00635a4a3fea8231ad3c"
    sha256 cellar: :any_skip_relocation, catalina:       "784c162c6957906919ef2ba71aabc5ca3a657cb3a0df8b4057d101d377cee5b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a37de2b23f8f07d7ab0a70e97e9a2a2449b20d84845900b2b7c238297caa5a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "144a8bb935684cfc3e836dc09d6681dcb31f5a3ca9adabf0aa9681862b9d7f92"
  end

  head do
    url "https://github.com/linbox-team/fflas-ffpack.git", using: :git
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
    system "autoreconf", "-vif"
    system "./configure",
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
