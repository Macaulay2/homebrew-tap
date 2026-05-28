class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.2/givaro-4.2.2.tar.gz"
  sha256 "53e9fb290deb0e20799c62d250d65c2226013d60b4cebe6b0b54c73000cb8fff"
  license "CECILL-B"

  head "https://github.com/linbox-team/givaro.git", using: :git, branch: "master"

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
