class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.1/normaliz-3.9.1.tar.gz"
  sha256 "ad5dbecc3ca3991bcd7b18774ebe2b68dae12ccca33c813ab29891beb85daa20"
  license "GPL-3.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.1_2"
    sha256 cellar: :any,                 big_sur:      "db00ee07a0f66346ff6a3e18a7204cb3429acfddb8f7388c6672645b6d486558"
    sha256 cellar: :any,                 catalina:     "8e1e4435285f3ce5d1568fc3d026c4af80ba902644a536f859f7f360f4b46c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3d9bd27e2748cbfd6eb77b2e89490e9d8e3f877eb8ec3abf108ba53eec990513"
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
