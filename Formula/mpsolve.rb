class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-3.2.1.tar.gz"
  sha256 "3d11428ae9ab2e020f24cabfbcd9e4d9b22ec572cf70af0d44fe8dae1d51e78e"
  license "GPL-3.0-only"
  revision 3

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mpsolve-3.2.1_3"
    sha256 cellar: :any,                 catalina:     "a349ab60a3da6f088d503562dd3b08b5e95d1030f2baa37804ef592844ab7659"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "900517e73fe5645adfaf9c64f6269e405549486e0c33e9972020afe0a9e82397"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "mpfr"

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/35c3e5e5f03cb2e60baa8e69f8109afcdb5fdc7b/M2/libraries/mpsolve/patch-3.2.1"
    sha256 "ba5b6064c8a3e9d1894d764aacebe5a623daf1487c7cc44207599df1759036d7"
  end

  # remove on next release; see https://github.com/robol/MPSolve/issues/27
  patch do
    url "https://github.com/robol/MPSolve/commit/3a890878239717e1d5d23f574e4c0073a7249f7a.patch?full_index=1"
    sha256 "b2c5e037bed14568d3692cf7270428614f2766bcaf0b2fb06a7f178497671efa"
  end

  def install
    ENV.cxx11
    system "autoreconf", "-vif"
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--disable-examples",
           "--disable-ui",
           "--disable-documentation",
           "GMP_CFLAGS=-I#{Formula["gmp"].include}",
           "GMP_LDFLAGS=-L#{Formula["gmp"].lib}",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
