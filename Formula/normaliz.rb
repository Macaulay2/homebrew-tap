class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.1/normaliz-3.10.1.tar.gz"
  sha256 "365e1d1e2a338dc4df1947a440e606bb66dd261307e617905e8eca64eaafcf6e"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.10.1"
    sha256 cellar: :any,                 ventura:      "b8cbec583456a6437627333ea2842f1dec0ccf8f54a1613efda6cfab4223a897"
    sha256 cellar: :any,                 monterey:     "dd036d66eee8313b452b3ea746890c2c4acc8408de10860fc7f474fa739181a2"
    sha256 cellar: :any,                 big_sur:      "387e82eaccda9c68076f3db6848792a57485c83a4f1a039f9f635fcd6bfeefc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "906077f6c60a11e47aa23b6cdc71af3a6e4f79e9f5d21cb58d5918644c701e69"
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
