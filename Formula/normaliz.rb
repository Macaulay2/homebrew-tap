class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.1/normaliz-3.11.1.tar.gz"
  sha256 "9a00d590f0fdcad847e2189696d2842d97ed896ed36c22421874a364047f76e8"
  license "GPL-3.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_tahoe:   "e589c87d95364b4ee1bef9b4427944d3e1f6dad2d582e213a1a33c5161262ce1"
    sha256 cellar: :any, arm64_sequoia: "15175f4a6a8471fe8299b3ff0ea6f3e1554b0c44dc6bd503fa3c2a5a15ccd831"
    sha256 cellar: :any, arm64_sonoma:  "c6276d5009be0b1bba601756a8a0540cfd4eb542ab33228bb6c7de70cb7d43c1"
    sha256 cellar: :any, x86_64_linux:  "1635e91c6824a5501fb052c4c860d8a357a2d8d07c487def9c74a9f047024827"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "flint"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "mpfr"
  depends_on "nauty"

  depends_on "eantic" => :recommended

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
    symlink "#{formula_opt_bin("libtool")}/libtool", "libtool"

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-cocoalib",
      "--with-flint",
      "--with-nauty",
    ]

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
    system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
