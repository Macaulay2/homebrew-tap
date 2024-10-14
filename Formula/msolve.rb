class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "b82bf7dfe1fb7d3064ecf95e0d0a01334820b09b1107368ca9b4d05ba9ee1241"
  license "GPL-2.0-or-later"

  head "https://gitlab.lip6.fr/safey/msolve.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "a97b7fa4eaf2174102a29c2e62b9e5949ee175e5c46fc8f8d7c898bf390d4cf9"
    sha256 cellar: :any,                 arm64_sonoma:  "5cc708a6c27c9a28f799e37fe9ee5d8dff8862a0cb6ce2a94484802906b051e1"
    sha256 cellar: :any,                 ventura:       "c114a47507523e44fc3c17dd0ce3fe852a889844784bd95829c1b5a6929418d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60f958250a36384a412d5dea321af4e56a8ff0cfb6c677b971d1c432de16e2b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "mpfr"

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OPENMP_CFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    end

    system "autoreconf", "-vif"
    system "./configure", *std_configure_args,
           "--disable-dependency-tracking",
           "--enable-openmp=yes",
           "CC=#{ENV.cc} #{ENV["OPENMP_CFLAGS"]}"
    system "make", "install"
  end

  test do
    (testpath/"eco10-31.ms").write <<-EOS
      x0,x1,x2,x3,x4,x5,x6,x7,x8,x9
      1073741827
      x0*x1*x9+x1*x2*x9+x2*x3*x9+x3*x4*x9+x4*x5*x9+x5*x6*x9+x6*x7*x9+x7*x8*x9+x0*x9-1,
      x0*x2*x9+x1*x3*x9+x2*x4*x9+x3*x5*x9+x4*x6*x9+x5*x7*x9+x6*x8*x9+x1*x9-2,
      x0*x3*x9+x1*x4*x9+x2*x5*x9+x3*x6*x9+x4*x7*x9+x5*x8*x9+x2*x9-3,
      x0*x4*x9+x1*x5*x9+x2*x6*x9+x3*x7*x9+x4*x8*x9+x3*x9-4,
      x0*x5*x9+x1*x6*x9+x2*x7*x9+x3*x8*x9+x4*x9-5,
      x0*x6*x9+x1*x7*x9+x2*x8*x9+x5*x9-6,
      x0*x7*x9+x1*x8*x9+x6*x9-7,
      x0*x8*x9+x7*x9-8,
      x8*x9-9,
      x0+x1+x2+x3+x4+x5+x6+x7+x8+1
    EOS
    system bin/"msolve", "-f", "eco10-31.ms"
  end
end
