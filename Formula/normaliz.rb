class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.9.3/normaliz-3.9.3.tar.gz"
  sha256 "0288f410428a0eebe10d2ed6795c8906712848c7ae5966442ce164adc2429657"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.9.3"
    sha256 cellar: :any,                 arm64_monterey: "439316e9f5fe04de036ffb5044ba68437b5e29f67c8542c865c864de9d43c2ff"
    sha256 cellar: :any,                 big_sur:        "f7b649d1a83f10b6c742b8ddfc9b993c8c200e12be3ea557250898ca42b7f3ac"
    sha256 cellar: :any,                 catalina:       "f7b67a1791f413de86fc9514a9b171ad0640a8011ac60820962eca17e4524ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29543517e4a9f0fa7d359b96f83d6c263e498b358861a72c6d34a11b136e9622"
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
