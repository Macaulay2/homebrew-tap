class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.0/givaro-4.2.0.tar.gz"
  sha256 "865e228812feca971dfb6e776a7bc7ac959cf63ebd52b4f05492730a46e1f189"
  license "CECILL-B"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/givaro-4.1.1_5"
    sha256 cellar: :any,                 big_sur:      "26c0c1a8381c8f076be3bde468b91f06fd15c957d60a6218328dd972c08e0201"
    sha256 cellar: :any,                 catalina:     "a577684e778f3b3eace871fad30cc090ee2534d57b461b3dd3945d7273b2ca6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8986b54704d78699e5262835816c8bd2f5639dd4a965215f365afd3c73c21675"
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
