class Barvinok < Formula
  desc "Software for counting lattice points and integration over convex polytopes"
  homepage "https://barvinok.sourceforge.io/"
  url "https://github.com/mahrud/barvinok.git", using: :git, revision: "e68bc088aefdd6d36172fa4cfb090de7874f8edf"
  version "0.41.8-M2"
  license "GPL-2.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_tahoe:   "18845b08f7aca814c4178cc36e6ab27f27ebc14d564320bbd78cbd066336c610"
    sha256 cellar: :any, arm64_sequoia: "780bb8bed57dded64f982c0a78a84becdbdd941891dd918b55300f432f110212"
    sha256 cellar: :any, arm64_linux:   "b4b16592b77eda7702907f8777cffe0718d0a4f9dd87673b29d63b050cc74324"
    sha256 cellar: :any, x86_64_linux:  "d891fee1bdf30e6f211722a0a4b7b41b8f4a5d36c8d2dd5fee66ac27e937bb07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "cddlib"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "isl"
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
           "--with-topcom=#{Formula["topcom"]}",
           "--with-isl=system"
    system "make", "install-strip"
  end

  test do
    system "true"
  end
end
