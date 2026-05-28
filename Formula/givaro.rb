class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.2/givaro-4.2.2.tar.gz"
  sha256 "53e9fb290deb0e20799c62d250d65c2226013d60b4cebe6b0b54c73000cb8fff"
  license "CECILL-B"

  head "https://github.com/linbox-team/givaro.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "f41a4c32e41fa93c2abdc7129b2f20b62ece60d8bf92bf1ab073b950f834e016"
    sha256 cellar: :any,                 arm64_sequoia: "6bde2ddd56fdac27412094e108a3b735f370048a09a3e1a2f3c4c0e3722a085c"
    sha256 cellar: :any,                 arm64_sonoma:  "75f1538ef24e4c6e221a2c6175bf3c9bf559ae51915bfb050e5b4439007142a0"
    sha256 cellar: :any,                 sequoia:       "9152dce45e67bc7b51defb31bf17f03a25abbf9d3713a18f87283d15b7db6689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8f557a896a7c05b2078bd8498d60e304e4fad74cdcdb73238ad04f3fcd6c6f"
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
