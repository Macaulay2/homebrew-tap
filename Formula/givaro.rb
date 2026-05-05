class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.1/givaro-4.2.1.tar.gz"
  sha256 "feefb7445842ceb756f8bb13900d975b530551e488a2ae174bda7b636251de43"
  license "CECILL-B"
  revision 1

  head "https://github.com/linbox-team/givaro.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "5e3740a64b821581773293243a5369fbd3154716b414c8ef941af2e2e2b5b989"
    sha256 cellar: :any,                 arm64_sequoia: "4099c36680d0deae35613d679f642f6b27ac6345845075976016af956e536caa"
    sha256 cellar: :any,                 arm64_sonoma:  "b73ccc7f666b835f25fe7ca935cedf555aa001b35f1205419c3c09e50372f07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "085c07e5d65ba868b309e7254efaed46d980647b51f3467d3fb0a1f678d199f0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

  # fix build w/ xcode clang 21 (https://github.com/linbox-team/givaro/pull/240)
  patch do
    url "https://raw.githubusercontent.com/sagemath/sage/7c36f8500f2ba57e5413718af56f5741bdac8b69/build/pkgs/givaro/patches/240.patch?full_index=1"
    sha256 "402445d165e88c8dd5dc69e810dab858bec351668911d7ff937f0e00ff0c25e0"
  end

  def install
    ENV.cxx11
    system "autoreconf", "-vif"
    system "./configure",
           "--with-gmp=#{Formula["gmp"].prefix}",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
