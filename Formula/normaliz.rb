class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.1/normaliz-3.10.1.tar.gz"
  sha256 "365e1d1e2a338dc4df1947a440e606bb66dd261307e617905e8eca64eaafcf6e"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.10.0"
    sha256 cellar: :any,                 arm64_ventura: "4d6264358ecc2d43fa43ae32f57268fd3ae7391223e27f36c009a8664e8c3911"
    sha256 cellar: :any,                 ventura:       "c4db1f93281f98725ac4c4b16787dd0319314bc4e76f013faa4cb3099c86eb65"
    sha256 cellar: :any,                 monterey:      "eaa9345ba4db64c8c49dd0bc3999194bc95a343a079f368218c5ca327f185338"
    sha256 cellar: :any,                 big_sur:       "7b3c1b0b4e3196b364a18a3995b82d97587e6490b7bd168a32b21511d87ea240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8eadb5ba333a11d4024b672f55847e6a42f19f2f9a5f4c7c5889b735767f5b9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?

  depends_on "flint" => :optional
  depends_on "nauty" => :optional

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
