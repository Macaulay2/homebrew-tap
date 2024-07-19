class Normaliz < Formula
  desc "Affine monoids, vector configurations, lattice polytopes, and rational cones"
  homepage "https://www.normaliz.uni-osnabrueck.de/"
  url "https://github.com/Normaliz/Normaliz/releases/download/v3.10.3/normaliz-3.10.3.tar.gz"
  sha256 "0aeb58fbbca362ed759f338a85e74156ed411e2846cc395f52d23ae90022ec91"
  license "GPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sonoma: "b06a45b15e587ffb9304540ef3125f8e0bccd8df6e2e2efe368fcddfc04fed74"
    sha256 cellar: :any,                 ventura:      "0606093989ec24a10553ab6ba4de9cf619301af62e5421175843fb0204876afc"
    sha256 cellar: :any,                 monterey:     "150b469ea730cf0b861fe643b7588b8d06c30e03ba95b35ab8668a4d4bc3446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "70479376aa304efea149c55b920797da54e02eb81f61ac5f13e46d9e6231795d"
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
    # c.f. https://github.com/Normaliz/Normaliz/issues/426
    ENV["LDFLAGS"] = "-L#{Formula["gmp"].lib} -lflint -lgmp"

    # replace the outdated libtool that ships with normaliz
    symlink "#{Formula["libtool"].opt_bin}/libtool", "libtool"
    with_eantic = build.with? "eantic"
    with_flint = build.with? "flint"
    with_nauty = build.with? "nauty"

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-cocoalib",
      with_eantic ? "--with-e-antic" : "--without-e-antic",
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
