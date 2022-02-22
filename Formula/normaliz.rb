class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.2/normaliz-3.9.2.tar.gz"
  sha256 "434265281d4ac1a4e0c440403659a4ff92834508bb4f92c0d262387b44a18ee0"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.2"
    sha256 cellar: :any,                 big_sur:      "1fcad90123fea2d1862f1487d8a3ffe9829e576622a631b6bc834cfc10287304"
    sha256 cellar: :any,                 catalina:     "d4488ea79f93dd9d85d826b58b511171d0d3a71d0986ce5379599a1ebc919cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "202304629857a2a0396f8188b1d7fb02e2874b1f19be6a908cc15bacef383983"
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
      ENV["OPENMP_CXXFLAGS"] = "-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
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
