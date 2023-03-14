class Topcom < Formula
  desc "Triangulations of point configurations and oriented matroids"
  homepage "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM/index.html"
  url "https://www.wm.uni-bayreuth.de/de/team/rambau_joerg/TOPCOM-Downloads/TOPCOM-1_1_2.tgz"
  sha256 "4fb10754ee5b76056441fea98f2c8dee5db6f2984d8c14283b49239ad4378ab6"
  license "GPL-2.0-only"
  revision 6

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/topcom-1.1.2_5"
    sha256 cellar: :any, arm64_monterey: "233d55e9b07d3aca283ad6dc22c6dadc3826bc4d778efd29ff8b05fe0f067a03"
    sha256 cellar: :any, monterey:       "efab76d0cad36aa7c24e4c9024ae0e897a4727b16b04017b36261db569ac8664"
    sha256 cellar: :any, big_sur:        "32499f758f1aad40512fb7a15a0ad6699bc3fea9cfede7a4a13af96cd23acc96"
    sha256 cellar: :any, catalina:       "33861026c46157d77ca7989ef705385586724b0f1ab923dc0039ad2a5054a824"
    sha256               x86_64_linux:   "dc4297dd06d343181355aafcb5dfe2ceb8e51382852e9cde8a66adbea3698b0a"
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
