class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://gitlab.lip6.fr/safey/msolve.git", tag: "v0.1.2", revision: "e62794b7bd3b7c34fca5364017c278e116abc1ab"
  license "GPL-2.0-or-later"
  revision 1

  head "https://gitlab.lip6.fr/safey/msolve.git"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/msolve-0.1.2"
    sha256 cellar: :any,                 catalina:     "9094675e03edb49a35af23a55f7142ae609432d4d75080dc45362bf76ba61f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "92c9124e118fd3c778e0deba7da122f7417db2a16bcc5462ab8852bbfabc2c63"
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
      ENV["OpenMP_CFLAGS"] = "-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
    end

    system "autoreconf", "-vif"
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--libdir=#{lib}"
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
    system "msolve", "-f", "eco10-31.ms"
  end
end
