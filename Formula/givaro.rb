class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/Macaulay2/givaro.git", using: :git, branch: "master"
  version "4.1.1"
  license "CECILL-B"
  revision 4

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/givaro-4.1.1_4"
    cellar :any
    sha256 "1ea7a960637a39ce6ed8729b2657bae825792ef03cbe5fc9667979bac70820d7" => :catalina
    sha256 "82bbd9239d94bcc2f9f1ffad6624b43c6825ef32e6f998f62f40f558ae4e125c" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/givaro.git", using: :git
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
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
