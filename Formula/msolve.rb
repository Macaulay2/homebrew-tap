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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6279bf5b65983d29087a7c51b0c3fe324dbf3919e9c34041ba85e880c9bf6995"
    sha256 cellar: :any,                 arm64_sonoma:  "27c8407b6022935e74fabd1a1d9d5c69daf5ab1b7d7f459c6e5411ef6dba780d"
    sha256 cellar: :any,                 ventura:       "80e901855f38c62fc55915b4c2deb57c69cac34b829e27503e6e017ed214f804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f9e21c4a39cff1702e6e3c44340a33e05369976c40af877181616cfee66d0d"
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
