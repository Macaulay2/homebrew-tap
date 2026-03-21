class Barvinok < Formula
  desc "Software for counting lattice points and integration over convex polytopes"
  homepage "https://barvinok.sourceforge.io/"
  url "https://github.com/mahrud/barvinok.git", branch: "main", using: :git
  version "0.41.8-M2"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "03f684954e9ff6211a529df2bd9e388696b709b58f8d5c52e26a106662939ec3"
    sha256 cellar: :any,                 arm64_sequoia: "c81cb6f2ac7953d94cc37e69434ed7a61f889a963006756cbbc479ffe5b01510"
    sha256 cellar: :any,                 arm64_sonoma:  "74f8fc39e49246cc02d7015524826a88436bf1f1e85eb83a97899227d059823b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0d7b1a00e4ba87f16736dd997ae43380b5938a51c2d1d676d4f31680fc0c82"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "cddlib"
  depends_on "gmp"
  depends_on "ntl"
  depends_on "topcom"

  def install
    # Also install vector_partition_chambers executable
    inreplace "Makefile.am", "bin_PROGRAMS = ", "bin_PROGRAMS = vector_partition_chambers "

    ENV.append "CPPFLAGS", "-fno-common -I#{Formula["gmp"].include} -I#{Formula["ntl"].include}"
    ENV.append "LDFLAGS", "-L#{Formula["gmp"].lib} -L#{Formula["ntl"].lib}"
    ENV.append "LDFLAGS", "-Wl,-twolevel_namespace" if OS.mac?

    system "autoreconf", "-vif"
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
           "--with-topcom=#{Formula["topcom"]}"
    system "make", "install-strip"

    # Brew is offended by non-library files in the lib directory
    rm lib/"libisl.23.dylib-gdb.py" if OS.mac?
  end

  test do
    system "true"
  end
end
