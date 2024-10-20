class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.7.tar.gz"
  sha256 "ab833757e1e4d4a98662f4aa691394013ea9a226f6416b8f8565356d6fcc989e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "87a38b372411fb7a2d4ef30a4b24669a5cd822230f75d947c11a2299f8ddf284"
    sha256 cellar: :any,                 arm64_sonoma:  "7289ab44d74c4ea08b0dade5dbb31a6ec74bfbde34dc4ddc2d618c2593cdf7bd"
    sha256 cellar: :any,                 ventura:       "542543eb68cb50d2b13b0fe597f4659fbf1ef8fcb05df72b85fbc382234114cb"
    sha256 cellar: :any,                 monterey:      "cfb015c8aa3422d9ccd80dbd5dc7ebae3e10dcd9d87e4103183e498edd6ae431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac80a1fd89713e142750d8adf6f976e4249d38f58c5c2eafcfc0f6aec35793a"
  end

  depends_on "gcc@14" => :build

  depends_on "cddlib"
  depends_on "gmp"

  patch :DATA

  def install
    linker_args = "-L#{Formula["cddlib"].lib} -static-libgcc -static-libstdc++"
    cxx_flags = "-I#{Formula["cddlib"].include}/cddlib"
    cxx_flags << " -D_64BITLONGINT" unless OS.mac?

    system "make", "PREFIX=#{Formula["gcc@14"].bin}/", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG #{cxx_flags}",
           "CCLINKER=#{Formula["gcc@14"].bin}/g++-14 #{linker_args}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/gfan", "_version"
    pipe_output("#{bin}/gfan _overintegers --groebnerFan", "Q[x,y]\n{x^2-y^2,2*x}\n", 0)
    pipe_output("#{bin}/gfan _tropicalfunction", "Q[x1,x2,x3]\n{x1*x2+x3^2}\n", 0)
    pipe_output("#{bin}/gfan _secondaryfan", "{(1,0),(1,1),(1,2),(1,2)}\n", 0)
  end
end

__END__

diff --git a/Makefile b/Makefile
index 67c8164..fe6e00b 100644
--- a/Makefile
+++ b/Makefile
@@ -113,13 +113,12 @@ MKDIR=mkdir -p

 # PREFIX = /usr/local/gcc/6.2.0/bin/
 # PREFIX = /usr/local/gcc-8.1/bin/
-PREFIX =
 SHELL       = /bin/sh
 #ARCH        = LINUX

-CC          = $(PREFIX)gcc
+CC          = $(PREFIX)gcc-14
 CLINKER     = $(CC)
-CXX         = $(PREFIX)g++
+CXX         = $(PREFIX)g++-14
 CCLINKER    = $(CXX)

 #CC          = $(PREFIX)gcc-8.1
diff --git a/src/gfanlib_circuittableint.h b/src/gfanlib_circuittableint.h
index 2b5ced4..b5bf6ed 100644
--- a/src/gfanlib_circuittableint.h
+++ b/src/gfanlib_circuittableint.h
@@ -25,6 +25,7 @@ namespace gfan{
   template<typename> struct MyMakeUnsigned;
   template <> struct MyMakeUnsigned<int>{typedef unsigned int type;};
   template <> struct MyMakeUnsigned<long int>{typedef unsigned long int type;};
+  template <> struct MyMakeUnsigned<long long int>{typedef unsigned long long int type;};
   template <> struct MyMakeUnsigned<__int128>{typedef unsigned __int128 type;};

   class MVMachineIntegerOverflow: public std::exception
@@ -92,6 +93,15 @@ static std::string toStr(__uint32_t b)
        return s.str();
 }

+#ifndef _64BITLONGINT
+static std::string toStr(long int b)
+{
+       std::stringstream s;
+       s<<b;
+       return s.str();
+}
+#endif
+
 class my256s{
 public:
        __int128_t lo,hi;
@@ -213,6 +221,10 @@ static __int128_t extMul(long int a, long int b)
 {
        return ((__int128_t)a)*((__int128_t)b);
 }
+static __int128_t extMul(long long int a, long long int b)
+{
+       return ((__int128_t)a)*((__int128_t)b);
+}

 static __uint128_t unsignedProd64(uint64_t x,uint64_t y)
 {
diff --git a/src/gfanlib_z.h b/src/gfanlib_z.h
index f56597c..8c84ed1 100644
--- a/src/gfanlib_z.h
+++ b/src/gfanlib_z.h
@@ -9,6 +9,7 @@
 #define LIB_Z_H_

 #include <string.h>
+#include <cstdint>
 #include <ostream>
 #include <iostream>
 #define OLD 1
-- 
2.46.0
