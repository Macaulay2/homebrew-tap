class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.1/normaliz-3.9.1.tar.gz"
  sha256 "ad5dbecc3ca3991bcd7b18774ebe2b68dae12ccca33c813ab29891beb85daa20"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.1"
    sha256 cellar: :any,                 catalina:     "46684bf73aac62578b01324b253bfce7c475506028adfc122e03b641ad8bae5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0976328d85cbdff7ebbc23e7d20e9efbe9d30458fde1e409696e99232965f7a3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "nauty"

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
    symlink "#{Formula["libtool"].opt_bin}/libtool", "libtool"
    system "autoreconf", "-vif"
    system "./configure", "--prefix=#{prefix}",
           "--without-flint",
           "--disable-shared",
           "--disable-silent-rules",
           "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "true"
  end
end
