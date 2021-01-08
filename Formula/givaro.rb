class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/mahrud/givaro.git", using: :git, branch: "master"
  version "4.1.1"
  license "CECILL-B"
  revision 3

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/givaro-4.1.1_2"
    cellar :any
    sha256 "7e8760fbebdee961d0cbfe788de355de24f55b9d57db339c30a10449fc13fcbb" => :catalina
    sha256 "6679d57f0f5e2043fa132d3f8478e291ea4c0a662c72664a9169955f15757ba5" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/givaro.git", using: :git
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

  def install
    ENV.cxx11
    system "./autogen.sh",
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
