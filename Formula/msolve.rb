class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/releases/download/v0.5.0/msolve-0.5.0.tar.gz"
  sha256 "13ad04757b0ba0bd44cf9a5abcf5aff416d5560b035323e9561ad4d4c020cfe5"
  license "GPL-2.0-or-later"

  head "https://gitlab.lip6.fr/safey/msolve.git"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/msolve-0.4.9"
    sha256 cellar: :any,                 arm64_ventura: "89320b6e99024d63c65dbf26cc0d644d75c63d751e3fbe96fae7e11cfb635f3d"
    sha256 cellar: :any,                 ventura:       "cc358fe27e6aff09c2ea59a1b7c87ae4aa5e3656c685acfa9be5b0a02a9bc61f"
    sha256 cellar: :any,                 monterey:      "0efcec6d01fde9d2dc7ed4bf67129d2cc8e00035b5ce859de0316be14b6f9ffd"
    sha256 cellar: :any,                 big_sur:       "e584b3da5dc1f1f37eb683b74f75e730caf80bb66f3ce8e96d1daebc3bdfa068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3429faafdfa54eddf04003acb6856d86b969a34c58f82b6f0c4a40a9f2b86dd"
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
