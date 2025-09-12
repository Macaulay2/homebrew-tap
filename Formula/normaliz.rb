class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.5/normaliz-3.10.5.tar.gz"
  sha256 "58492cfbfebb2ee5702969a03c3c73a2cebcbca2262823416ca36e7b77356a44"
  license "GPL-3.0-only"
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "1ea03da6f6019437a4e75304b855c5220a3e2def84075c913f8a3a25188a29ac"
    sha256 cellar: :any,                 arm64_sonoma:  "e325289c133bec65a4efee39f487bb7b3f6266b04dc9dd04332875cb7d5a48d0"
    sha256 cellar: :any,                 ventura:       "b33ace7f33d0e08cee04a1f2eb1cf1ad0f171261b17e2630dfa5815ec4f2ade1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52686acfaa004e415ec068acac1b6d9d64a93ec2728a1048d2882ec599268116"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "diffutils" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

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
