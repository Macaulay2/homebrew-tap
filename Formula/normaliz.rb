class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.2/normaliz-3.10.2.tar.gz"
  sha256 "0f649a8eae5535c18df15e8d35fc055fd0d7dbcbdd451e8876f4a47061481f07"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.10.2"
    sha256 cellar: :any,                 arm64_sonoma: "0bd6eb821a64fbe04cbc56d6349baf08df547ab5d4a33e727e5a11d9ebdd6b23"
    sha256 cellar: :any,                 ventura:      "7e262b5e222a88cf3bbde55f2d174dfa4cc258ecf33292d8c4c768ac2c38c96d"
    sha256 cellar: :any,                 monterey:     "8f9debc426f4ec7fca2dc787dc117b00a1f5e68d46be2bdc55d9abc5fa820407"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a9e79896b9ee78e07564d3788c1c25d2e353497f19d9014c8156f22f53a48a1b"
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
