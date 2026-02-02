class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.1/normaliz-3.11.1.tar.gz"
  sha256 "9a00d590f0fdcad847e2189696d2842d97ed896ed36c22421874a364047f76e8"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1980b5d8bbc92c21f5e4ee5bfa93710b6834767a7648275f877e56749a411553"
    sha256 cellar: :any,                 arm64_sequoia: "e5fda81af6beafa0dbd271f223dc7fde0dd27b1e2dd6e11bf0dd94ca8c532078"
    sha256 cellar: :any,                 arm64_sonoma:  "cac4266a4e1afff497b71f45b9ee4b7a7121ec04fcfb056a278d7e94d98a3b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c660771a61d777c63cae957b04cc7ff707c6eaf22899cae950fb4e952455d47d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?

  depends_on "eantic" => :recommended
  depends_on "flint" => :recommended
  depends_on "nauty" => :recommended

  def install
    ENV.cxx11
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OPENMP_CXXFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    else
      ENV["OPENMP_CXXFLAGS"] = "-fopenmp"
    end

    ENV["CPPFLAGS"] = "-I#{Formula["gmp"].include}"
    ENV["LDFLAGS"] = "-L#{Formula["gmp"].lib}"

    # replace the outdated libtool that ships with normaliz
    symlink "#{Formula["libtool"].opt_bin}/libtool", "libtool"
    with_flint = build.with? "flint"
    with_nauty = build.with? "nauty"

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-cocoalib",
      with_flint ? "--with-flint" : "--without-flint",
      with_nauty ? "--with-nauty" : "--without-nauty",
    ]

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
    # Disabled pending https://github.com/Normaliz/Normaliz/issues/436
    # system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
