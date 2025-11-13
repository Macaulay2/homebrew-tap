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
    sha256 cellar: :any,                 arm64_tahoe:   "29eec53334c920bc0b1f61e7410054535a95bc640816ad6718b88615dbf1a9c7"
    sha256 cellar: :any,                 arm64_sequoia: "8a02dc5f4a96404f7b2bf835161c784758a078fe5e0468e82b19ded88af1ebc1"
    sha256 cellar: :any,                 arm64_sonoma:  "e12ec93e4ec4bed5b074fbe1c9f21ce430a6504e4c30fce7c55c1acb269facab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2a646a44caacccfedb68ee034ccd5ce51c07da82c875aaa95c7d9f5d8a54007"
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
