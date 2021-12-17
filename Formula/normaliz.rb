class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.1/normaliz-3.9.1.tar.gz"
  sha256 "ad5dbecc3ca3991bcd7b18774ebe2b68dae12ccca33c813ab29891beb85daa20"
  license "GPL-3.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.1_1"
    sha256 cellar: :any,                 big_sur:      "2f03ca8e178351f6f6a95bc1c33ab684e1abe4f9691e2a2efef38232c42464d2"
    sha256 cellar: :any,                 catalina:     "967ec6cb39e3144f2ba2c8a6360fdb55e3217820e5fb9657b4d174dc68946425"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6b3699498d7f8563c6729a95426acd204872b02333b9067937e3ccfd0f45a9ae"
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
