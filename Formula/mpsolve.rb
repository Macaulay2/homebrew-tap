class Mpsolve < Formula
  desc "Multiprecision Polynomial SOLVEr"
  homepage "https://numpi.dm.unipi.it/software/mpsolve"
  url "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-3.2.1.tar.gz"
  sha256 "3d11428ae9ab2e020f24cabfbcd9e4d9b22ec572cf70af0d44fe8dae1d51e78e"
  license "GPL-3.0-only"
  revision 4

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

  # see https://github.com/robol/MPSolve/issues/38
  patch :DATA

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

__END__

diff --git a/include/mps/private/system/memory-file-stream.h b/include/mps/private/system/memory-file-stream.h
index 0029bc9..a11b998 100644
--- a/include/mps/private/system/memory-file-stream.h
+++ b/include/mps/private/system/memory-file-stream.h
@@ -47,6 +47,8 @@ MPS_END_DECLS
 
 #ifdef __cplusplus
 
+#undef isnan
+#undef isinf
 #include <iostream>
 #include <sstream>

--
2.40.1
