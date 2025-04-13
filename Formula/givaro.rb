class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.1/givaro-4.2.1.tar.gz"
  sha256 "feefb7445842ceb756f8bb13900d975b530551e488a2ae174bda7b636251de43"
  license "CECILL-B"

  head "https://github.com/linbox-team/givaro.git", using: :git

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "351581d743e80d0e2cc96fa7befc86ee67aff2fb0146d0ce06f62aed2f81114d"
    sha256 cellar: :any,                 arm64_sonoma:  "d90dc5644da6c022c1d9ac6b48866ac17c4aac563dbb31159b5d64bb3c7722c5"
    sha256 cellar: :any,                 ventura:       "e4d8b545e7fd38f455b31a8e8dd7a65bc4c2a13414d6a5dc328544d197c06702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a9ff74990fd5e35895b2e25fe663d93b60d66b45da8d8597b94d35b79c3981"
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
