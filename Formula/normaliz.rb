class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.1/normaliz-3.11.1.tar.gz"
  sha256 "9a00d590f0fdcad847e2189696d2842d97ed896ed36c22421874a364047f76e8"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "262d4b935a97f7a3bbb12a971d64c1712360f60b514b0039c6021a1af850e5b1"
    sha256 cellar: :any,                 arm64_sequoia: "103504736c99e5fe070a1e4eefe83caf5915b71ab04e25ec666a570fdcbb4b10"
    sha256 cellar: :any,                 arm64_sonoma:  "21f69463b4659a44a68992cec38dcbbf58564daac6edd0531706fc61948c236f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a86a28d7c171ccf0964b5e4ea8d87c7b49b7dc706cb4e49cc6bf72d7a93c7a"
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
    symlink "#{Formula["libtool"].opt_bin}/libtool", "libtool"

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
