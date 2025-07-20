class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.5/normaliz-3.10.5.tar.gz"
  sha256 "58492cfbfebb2ee5702969a03c3c73a2cebcbca2262823416ca36e7b77356a44"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7203b0cf9140cfb26b2f9d5ec3bf51de3662401f8f86c07aa790e3e4415be13a"
    sha256 cellar: :any,                 arm64_sonoma:  "1b6e505e571aee55d40ec0d950ee08dcb110797f1c40afe02f5fa86bd069037c"
    sha256 cellar: :any,                 ventura:       "d72baf8df2435ea9a5962a93c60af00e0ce077c91b72f69d2ef42729c4041606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744e66f25ecb39f207dc127b7ebfe8f3aa0cd7fd27c618c467a9c4eaedb146ed"
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
    # with_nauty = build.with? "nauty"

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-cocoalib",
      with_flint ? "--with-flint" : "--without-flint",
      # with_nauty ? "--with-nauty" : "--without-nauty",
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
