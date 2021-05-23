class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.8.10/normaliz-3.8.10.tar.gz"
  sha256 "d085c64bebcb23e1c607ca1daff4551a9d38dd8f3dfbef4ef49670b58bb27f65"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/normaliz-3.8.9_2"
    sha256 cellar: :any, catalina:     "807d7da3a2f145c12414135df2b17418facbe43d175425c1f4356fb2df53c2fe"
    sha256 cellar: :any, x86_64_linux: "5a3bb78cdb0226407715a45d315037c2b0cfba709f86bd0f275ce8f8ecd20dfc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "nauty"

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/83056083c62b734102a7b8f1e4c875c0c4456996/M2/libraries/normaliz/patch-3.8.5"
    sha256 "2b984d9f5d08a44df6a1a065c0c1e51b1ef3beb8a1c938484dea4333ad71962b"
  end

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
