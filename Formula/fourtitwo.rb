class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/releases/download/Release_1_6_9/4ti2-1.6.9.tar.gz"
  sha256 "3053e7467b5585ad852f6a56e78e28352653943e7249ad5e5174d4744d174966"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fourtitwo-1.6.9_1"
    sha256 cellar: :any,                 arm64_monterey: "e03d318e30f74cb384b2abb62301b6ba6974bdfe95ef93484e3fc93cc80f4388"
    sha256 cellar: :any,                 big_sur:        "ce0d7ed1e2aef4a358e2b3961969c79cd28898357517a550120279e853e5c368"
    sha256 cellar: :any,                 catalina:       "d98a4cdf6356e5f1711969f1b06035004a16b265214dd84290797075b3457427"
    sha256 cellar: :any,                 monterey:       "5578687a70da0b4333386aa94489c405c70ce53002aead36504f1de3805598d8"
    sha256 cellar: :any,                 ventura:        "54f7fcef9c462e0efe29f03b2f62ed867529b07ecb10282b8e07e09902be8371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ac3d558537776b89e453ff69b53009686b68afaf8b9e2be076c46c576f75ba2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "glpk"
  depends_on "gmp"

  def install
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--with-glpk=#{Formula["glpk"].prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include}",
           "LDFLAGS=-L#{Formula["gmp"].lib}",
           "--prefix=#{prefix}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
