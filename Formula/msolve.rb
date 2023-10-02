class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/releases/download/v0.5.0/msolve-0.5.0.tar.gz"
  sha256 "13ad04757b0ba0bd44cf9a5abcf5aff416d5560b035323e9561ad4d4c020cfe5"
  license "GPL-2.0-or-later"

  head "https://gitlab.lip6.fr/safey/msolve.git"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/msolve-0.5.0"
    sha256 cellar: :any,                 ventura:      "e74eaf14dab9f9c0bb0a6b333907728fa44ea04db0aaf1b4a9e3822bbfdd9a20"
    sha256 cellar: :any,                 monterey:     "e3d62244a8d05fd5ce6922ebb8638307083854e13cf65bcb705b38e2ac178fa2"
    sha256 cellar: :any,                 big_sur:      "59fdbbb506b4dc87d9e029ef6126961ba6dfc901838801854cf11848c4b1b933"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e97245f88201f45fc0a0d70a0e1681c51d2506cfdac4c87a28a233bab9161bcf"
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
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--enable-openmp=yes",
           "--prefix=#{prefix}",
           "--libdir=#{lib}",
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
    system "#{bin}/msolve", "-f", "eco10-31.ms"
  end
end
