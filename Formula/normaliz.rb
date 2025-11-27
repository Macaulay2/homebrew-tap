class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.11.0/normaliz-3.11.0.tar.gz"
  sha256 "14441981afce3546c1c0f12b490714da3564af7a60d12ac0a494f9d2382d1a01"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9dab2d8aa8e21c021cd1fef29ae9033b3669ae1d510511f854abb7c4712670bc"
    sha256 cellar: :any,                 arm64_sequoia: "616c8d5a94ed94f7e13fd8069c4043546506f5163fb8e0457ef01aa8f9151557"
    sha256 cellar: :any,                 arm64_sonoma:  "59aca1a3d79a8b0966e8fe2e88f578f84ab7521a157ba96e5ec679763c8e56db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebedf2c018221e455ca1575721d4baa90bd1577db188ab1fa8f1e2481784a026"
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
