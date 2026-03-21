class Fourtitwo < Formula
  desc "Software for algebraic, geometric and combinatorial problems on linear spaces"
  homepage "https://4ti2.github.io/"
  url "https://github.com/4ti2/4ti2/releases/download/Release_1_6_15/4ti2-1.6.15.tar.gz"
  sha256 "070e639398fda1a4665b3291e5ea80f2ba280d9bffd50656ad8482d471b96965"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "66198bcf721898bf79d79f4120667a604b3828a09e96b844fe332657debd9662"
    sha256 cellar: :any,                 arm64_sequoia: "c1126a7b3ab6f2a5330e92d689e79aac61a560a6cf6b0cdb02ac2f1d41a3c360"
    sha256 cellar: :any,                 arm64_sonoma:  "767b13972d74f0e4d957cb2ad517d5011940acf4d3eff4ef1f1d7a8ebc627811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c966a0fdf0d34ccae2336031286a900c6db043efba8a7ac7840cd353baebe7dd"
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
           "CPPFLAGS=-I#{Formula["gmp"].include} -fPIC",
           "LDFLAGS=-L#{Formula["gmp"].lib} -fPIC",
           "--prefix=#{prefix}"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
