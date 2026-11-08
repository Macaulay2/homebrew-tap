class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/releases/download/Release_1_6_16/4ti2-1.6.16.tar.gz"
  sha256 "a45629835ac138bb17896c509278b956c11917ec58e57165a2ee0c54ed0307cb"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_golden_gate: "6f686684412ed617fd12f0b81f5297e668c8bf3f93f6be9b6fe1627977244c31"
    sha256 cellar: :any, arm64_tahoe:       "356ca099beb45c4f045ea3e3a737b6f4779549382ef6f287efe1c21d6af34bb7"
    sha256 cellar: :any, arm64_sequoia:     "058ec59b75b2c37814ff84386062478389ed6f6a46a3ab7b00da17e454bac31f"
    sha256 cellar: :any, arm64_linux:       "e945065572544853487b066cef2addaf8b9f7cefc159b1c217ddf62f347bd029"
    sha256 cellar: :any, x86_64_linux:      "07b561b918deaa64e77b24b281f172360840e909ea2948a93862c5a1f3f7046e"
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
