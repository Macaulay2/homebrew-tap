class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.0/normaliz-3.11.0.tar.gz"
  sha256 "14441981afce3546c1c0f12b490714da3564af7a60d12ac0a494f9d2382d1a01"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b399766e36631c355e2d3f07907554de4734b615e91e0c3838bcbcd902670d6d"
    sha256 cellar: :any,                 arm64_sequoia: "ba67db952ed5c33d22b99cc89c5caf3e16f23e9c23f9733cc887ed53634a0840"
    sha256 cellar: :any,                 arm64_sonoma:  "5d458c0c41d68e14c2db5c0e1297e6142a12b70e2a8931d823ea480f2e8aab34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08500ebb959fad85431cabeb4a8bdf6f3261de4a383cc9fcc7db3e59739c7584"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?

  depends_on "eantic" => :recommended
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
    with_flint = build.with? "flint"
    with_nauty = build.with? "nauty"

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-cocoalib",
      with_flint ? "--with-flint" : "--without-flint",
      with_nauty ? "--with-nauty" : "--without-nauty",
    ]

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
    # Disabled pending https://github.com/Normaliz/Normaliz/issues/436
    # system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
