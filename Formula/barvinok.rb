class Barvinok < Formula
  desc "Software for counting lattice points and integration over convex polytopes"
  homepage "https://barvinok.sourceforge.io/"
  url "https://barvinok.sourceforge.io/barvinok-0.41.8.tar.xz"
  sha256 "8b618450cd83aa1e1f25aef4765c6633634c25b980760aedce018e531b18e6fe"
  license "GPL-2.0-only"

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
