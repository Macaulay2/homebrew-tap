class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/releases/download/Release_1_6_9/4ti2-1.6.9.tar.gz"
  sha256 "3053e7467b5585ad852f6a56e78e28352653943e7249ad5e5174d4744d174966"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/fourtitwo-1.6.9"
    cellar :any
    sha256 "868c7c3724e64c614ccd15e61d15a4abe4bee5e7e090dfaf3dea3f29531b8ad1" => :catalina
    sha256 "03db527ac7d43339fb40696e012859822943bf9a64113b1f8bcb1f18b0cc502d" => :x86_64_linux
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
