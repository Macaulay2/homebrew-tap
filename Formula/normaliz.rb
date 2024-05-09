class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.2/normaliz-3.10.2.tar.gz"
  sha256 "0f649a8eae5535c18df15e8d35fc055fd0d7dbcbdd451e8876f4a47061481f07"
  license "GPL-3.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sonoma: "3d6a73000391874b63fb01c6eb107b8f9b825f9fa239ef2c0c31a6dad15ce820"
    sha256 cellar: :any,                 ventura:      "7f20f37885e8920b78575db3e2bd3dc3d22b2877ceb282ccab0b5dd0525094a8"
    sha256 cellar: :any,                 monterey:     "40415186d09f6c543643702491f08654ba1c1d304fdedcd6864280d75557a1ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "523cdfc3d3cf79504c3b8ac20e311271e3fbe054e55641d8c91e1a05c27ec4c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?

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
  end

  test do
    system "true"
  end
end
