class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/mahrud/givaro.git", using: :git, branch: "master"
  version "4.1.1"
  license "CECILL-B"
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/givaro-4.1.1"
    cellar :any
    sha256 "e0764d4480895c290baccb9dc18f2686927b68b2dc39f6b03b862c4f863f2f64" => :catalina
    sha256 "d3a9d88527d76fe7e505020e75c74abcb09fe0273b7f9ae85814898b04206dab" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/givaro.git", using: :git
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

  def install
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
