class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.2/normaliz-3.10.2.tar.gz"
  sha256 "0f649a8eae5535c18df15e8d35fc055fd0d7dbcbdd451e8876f4a47061481f07"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.10.2_1"
    sha256 cellar: :any,                 arm64_sonoma: "1db74cccd7cc744c11109e366abc74cc42329d8bc9a4ab40a83cf50163edfe34"
    sha256 cellar: :any,                 ventura:      "d967623ffa7ebc5ae86f98338a60af877ad3512e61c7324b9c2cbc5b0222fce0"
    sha256 cellar: :any,                 monterey:     "453f28b4ba2e9e42af7c5cd2e86d7bcab98b8ceb2a3230ce43ffcf3db38a850d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "366cb51ec5ff983d23c016f00afadbff001e458e7ec1940e8b2b93cf7e0ceaa1"
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

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
    ]

    args << "--with-flint" if build.with? "flint"
    args << "--with-nauty" if build.with? "nauty"

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
