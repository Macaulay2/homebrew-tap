class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/releases/download/Release_1_6_14/4ti2-1.6.14.tar.gz"
  sha256 "1bc340173f93ca4abd30ea962118bd5057fdedf7e79c71d2a0c4cc9569f8b0b1"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "22979583fbd09c6ab1cecb22637c2fb5dcd11270d4b1f221fca031f0288c1670"
    sha256 cellar: :any,                 arm64_sequoia: "93c14a2ad7b06ce5d53fdc9dcbf75c7cbe95e3333c9041b2eeae19109fe324e9"
    sha256 cellar: :any,                 arm64_sonoma:  "d6fb61b76578871f6ae0e87830283703cb03d0d2809447aa35ffd379e9e89691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c67c96bb41e11ab136302c79bcad87069f89b905422277ae4e52099c6ef90e9"
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
