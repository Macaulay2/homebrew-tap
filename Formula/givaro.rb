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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0045311cdf68e311387dd449ff0d20af1ed4e45d481932d976d095b90a0208e6"
    sha256 cellar: :any,                 arm64_sequoia: "107fcabca0fd67f001cb1b1ea5b7c274c517af4d0aa86ace88474c3e25e717f1"
    sha256 cellar: :any,                 arm64_sonoma:  "5678f719c7cda02888a524e0ce8941429215871105dbf1b04c76a4d34fae28f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695bb03526febd1a4ffa57caf26d00ad9598bdf4423d05cbf34d8edd85c674f6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

  # fix build w/ xcode clang 21 (https://github.com/linbox-team/givaro/pull/240)
  patch do
    url "https://github.com/linbox-team/givaro/commit/ed91ee0dc2d41f3ceb72abc375ad5c0fec62ed56.patch?full_index=1"
    sha256 "55a2ba7356b0b44a2c7957c7b179c6f9f920220b56a9e4dcbc4f945ff3073a3c"
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
