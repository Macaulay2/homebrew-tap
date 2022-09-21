class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-3.2.1.tar.gz"
  sha256 "3d11428ae9ab2e020f24cabfbcd9e4d9b22ec572cf70af0d44fe8dae1d51e78e"
  license "GPL-3.0-only"
  revision 4

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mpsolve-3.2.1_4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef92986f98ef651d1ca81619944547d9b49b3e649fe6edbb919032378d68cb9"
    sha256 cellar: :any,                 big_sur:        "44e44aaf82cbb84a46f902b276926e3aee8035b8296ca89b0cc3473517eea2c1"
    sha256 cellar: :any,                 catalina:       "4f5807e0ec5c5b340125f2b45df9ac3bd334ada899a7377cb8a2d2eef7774cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a3840be8c6d6b10b0bb00cff20a2206e0be42b501ccadfd26d60083f9a66447"
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
