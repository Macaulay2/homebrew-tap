class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.1/normaliz-3.11.1.tar.gz"
  sha256 "9a00d590f0fdcad847e2189696d2842d97ed896ed36c22421874a364047f76e8"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7cf0218d33afeb914c96235922a426e3955ff2fba863084cc7f94930bb9d7eb9"
    sha256 cellar: :any, arm64_sequoia: "d2f5599b7e1c1e1083728ec36336f9fe23e57f74900b11d859232f81480d3a25"
    sha256 cellar: :any, arm64_sonoma:  "a30f6e8f1ef37225687ab2cd230b7fc20af12e1b43ceeac65ebd112ce65effde"
    sha256 cellar: :any, x86_64_linux:  "60fb672716e46ced50936244be16d8ed8229b90185ba2992f557a9a465216c24"
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
