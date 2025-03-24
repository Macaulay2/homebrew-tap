class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.4/normaliz-3.10.4.tar.gz"
  sha256 "9b424f966d553ae32e710b8ab674c7887ddcbf0e5ea08af7f8bc1b587bcbb2aa"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "bdd0cb98f6340e4f833cab3a7b37ce50b2fdeda3a6949d55ad26aa0d0b5ff2f7"
    sha256 cellar: :any,                 arm64_sonoma:  "8be66ae4017b0a98415f29709447b0192bb069f818cdbef51ce4ab9bc901d6f2"
    sha256 cellar: :any,                 ventura:       "0a6daa1e357452f679e48e298d5ea6406c2cc58c19e5bbd5c7a2fa54b1c98420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacbc6b2f429d5b4ca93ab4b3ab7a0a273341eb0d7067bfb84319879277158c0"
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
    system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
