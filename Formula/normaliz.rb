class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.5/normaliz-3.10.5.tar.gz"
  sha256 "58492cfbfebb2ee5702969a03c3c73a2cebcbca2262823416ca36e7b77356a44"
  license "GPL-3.0-only"
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f3d9ab0cd737e522fbfe17d73381aac8dca167d4a23afb56ee82422383f41dcc"
    sha256 cellar: :any,                 arm64_sonoma:  "0e5df5236aee39d3c54edd31588275ea3e2c2290de64b59a5fcbf2b543a94a62"
    sha256 cellar: :any,                 ventura:       "5ee7b5844f5443b43891c9631c0ba756072603232f118028a7c4d9702637d10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cea29a5ab273e37c58646ff6dc5eac99dac91bc16021932e3a0b97e010bbd4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
