class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.4/normaliz-3.9.4.tar.gz"
  sha256 "fdfcec1bfd4586aee2c43040370e051c1cb28a3d4bdd8d77a62c0c0e0afb9a6f"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.4"
    sha256 cellar: :any,                 arm64_monterey: "cea8a4c0238a33253fc16504e458800909aac8dd651d41f36d887c8e10ae32a9"
    sha256 cellar: :any,                 big_sur:        "189e3340ef34abc2e1e77c5b8bf650cf3c91e9f3cce30ff671d5e878e3f45267"
    sha256 cellar: :any,                 catalina:       "ebe29792613bd778226c47d9b7b074f4019c7bb4731996d319209b77ff1fb217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7449e10e773d26f0020f3b64849c192cb2623c7f4b5c31b492952632d79aa116"
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
