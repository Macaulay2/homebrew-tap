class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.0/givaro-4.2.0.tar.gz"
  sha256 "865e228812feca971dfb6e776a7bc7ac959cf63ebd52b4f05492730a46e1f189"
  license "CECILL-B"
  revision 1

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

  patch do
    url "https://src.fedoraproject.org/rpms/givaro/raw/rawhide/f/218.patch"
    sha256 "20151b77f357d8fa0205bbd238a3d74d5d414d0db2a21446fcc047530eca0c96"
  end

  patch do
    url "https://src.fedoraproject.org/rpms/givaro/raw/rawhide/f/0001-Temporary-GCC-14-workaround.patch"
    sha256 "4dbba14012886dcd884864edbdf7599a0ea119dd9851c846a27998ca6eba8db3"
  end

  # https://github.com/linbox-team/givaro/issues/232
  patch do
    url "https://github.com/linbox-team/givaro/commit/a18baf5227d4f3e81a50850fe98e0d954eaa3ddb.patch?full_index=1"
    sha256 "16e3242c37e4ec38be1df5ef9b3af99cd84133b5f6d7ff767415e6711f05e296"
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
