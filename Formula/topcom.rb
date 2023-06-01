class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 6

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-1.1.2_6"
    sha256 cellar: :any,                 arm64_ventura: "3a7be1f7cb674b1ab31ebd06c8a6f93d112f93bbad3c0ef731e5e928f1af28e5"
    sha256 cellar: :any,                 ventura:       "6c8f018724d0b885ebe44507e9698f1e88d9ae7e39f4540d89809bd776511949"
    sha256 cellar: :any,                 monterey:      "123255b73771b5f28b0074b8569877adc509aea99f908cb32af88338a69ce2b4"
    sha256 cellar: :any,                 big_sur:       "e4b35050590e7639375aff7a20adb6fc863fccc1ad08e57c2988d8dbbb0aac34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acd391b45a89bc3a8368ca7a0fe0b1ed542da6ade9c82573232b995fab7a4e7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib"
  depends_on "gmp"

  def install
    # ENV.deparallelize
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "CPPFLAGS=-I#{Formula["gmp"].include} -I#{Formula["cddlib"].include}/cddlib",
           "LDFLAGS=-L#{Formula["gmp"].lib} -L#{Formula["cddlib"].lib}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
