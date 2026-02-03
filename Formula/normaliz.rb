class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.1/normaliz-3.11.1.tar.gz"
  sha256 "9a00d590f0fdcad847e2189696d2842d97ed896ed36c22421874a364047f76e8"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9e24f4f3888492cbb4c099ef6370c2757c8b5303f17ea7de03c4362d056c2c4f"
    sha256 cellar: :any,                 arm64_sequoia: "d3a457917878a07f4aa537eb3bf6889c18e8cae99cca105439cef97e888b6ba7"
    sha256 cellar: :any,                 arm64_sonoma:  "846f2a7e2d5ac3f9f45f5b786464534e23611cb8f944f7805e3544cc55dd6b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0c0dab4aac1387e222eaf93cbfba365b0cd68ba916826a50e26b6f652a1fab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "flint"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "mpfr"
  depends_on "nauty"

  depends_on "eantic" => :recommended

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
      "--without-cocoalib",
      "--with-flint",
      "--with-nauty",
    ]

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
    system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
