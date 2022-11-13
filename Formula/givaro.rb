class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.0/givaro-4.2.0.tar.gz"
  sha256 "865e228812feca971dfb6e776a7bc7ac959cf63ebd52b4f05492730a46e1f189"
  license "CECILL-B"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/givaro-4.2.0"
    sha256 cellar: :any,                 arm64_monterey: "a2dd485809f7d5e1f9955711478ff277480d9928c953b5521b06bfb617e40076"
    sha256 cellar: :any,                 big_sur:        "b755c38b4ef9c91eb0db616b6378240daed373c45400b10b518815fc21cc0e23"
    sha256 cellar: :any,                 catalina:       "de769e6a8ff99cb7dde345b19dd9db1e31eba9e88433730e8649c9e853235f6b"
    sha256 cellar: :any,                 monterey:       "b4b449126141f3b36d291ffd79fb0208e75b5089e856dbe931335dfff33349d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "909af3d560a72e11db51d01d739830f0a1a745450811986d41f21d41d236917d"
  end

  head do
    url "https://github.com/linbox-team/givaro.git", using: :git
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

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
