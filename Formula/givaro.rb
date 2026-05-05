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
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "04657983c0764c4b03452afd50f035e4976cfce8f212aeb5939b981353427f4d"
    sha256 cellar: :any,                 arm64_sequoia: "61feba11b5519b237d27fea82ba861047dfdfe288701996ec72d669395d93bbf"
    sha256 cellar: :any,                 arm64_sonoma:  "9f4eb120b0d037d6f5136c7fcbbe2c41922c013f56e5dad2525625b6a39fe43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee64ae9dbde581fa606950058c13f980562b12c1a9ed8cbe326e9ed465b5195"
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
