class Barvinok < Formula
  desc "Software for counting lattice points and integration over convex polytopes"
  homepage "https://barvinok.sourceforge.io/"
  url "https://barvinok.sourceforge.io/barvinok-0.41.8.tar.xz"
  sha256 "8b618450cd83aa1e1f25aef4765c6633634c25b980760aedce018e531b18e6fe"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "a72bd3ef20974f50c8e3ac6db28954fdf0bc8d2e783fe8714775b2a710b0433f"
    sha256 cellar: :any,                 arm64_sequoia: "9da64f902c1f70d79297c90c5b6130c23b1bfa3f665683adf13f099e863105fc"
    sha256 cellar: :any,                 arm64_sonoma:  "68c3a890c3511994fd2414a5dc67e81b31a62568939796197a2926a22ea7cd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc79f7aa88a8285455970139735120613346e19a25a1e3cc417a880e09e5b384"
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
    inreplace "Makefile.in", "bin_PROGRAMS = ", "bin_PROGRAMS = vector_partition_chambers$(EXEEXT) "

    ENV.append "CPPFLAGS", "-fno-common -I#{Formula["gmp"].include} -I#{Formula["ntl"].include}"
    ENV.append "LDFLAGS", "-L#{Formula["gmp"].lib} -L#{Formula["ntl"].lib}"
    ENV.append "LDFLAGS", "-Wl,-twolevel_namespace" if OS.mac?

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
