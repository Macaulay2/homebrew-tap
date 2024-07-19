class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "1491e2da3ef7c324d7ddf10ee8ffc8c5cd9b11825d09c859ca9f64836559605e"
  license "GPL-2.0-or-later"

  head "https://gitlab.lip6.fr/safey/msolve.git"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/msolve-0.6.5"
    sha256 cellar: :any,                 arm64_sonoma: "d4133b46fbe4d54af918cac99e81337319bbb20d11345fe81b83140632fd4a1f"
    sha256 cellar: :any,                 ventura:      "d42e530dc10786f2303fbddcff26a702ffb085574920a115ed6554cd67cb8f2f"
    sha256 cellar: :any,                 monterey:     "8dcf7573d6b49ffd85a1d39423008e7f38465298f6e1409120e8a8957e90e208"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45e28e0a6326d22493d64fc2a585f79c39b7f01062c8214da045228d95cad5eb"
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
