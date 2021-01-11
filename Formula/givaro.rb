class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/Macaulay2/givaro.git", using: :git, branch: "master"
  version "4.1.1"
  license "CECILL-B"
  revision 3

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/givaro-4.1.1_3"
    cellar :any
    sha256 "25ba990eeb936ff8d9c77f350bc98a43d4decdba51ca3d7c2558590a99ede783" => :catalina
    sha256 "6c3e748359fe61036e407086d5f02bb86c34fb926f23c16a802a476d75198564" => :x86_64_linux
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
