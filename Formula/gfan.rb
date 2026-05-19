class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.8beta.tar.gz"
  sha256 "fa7884e5f317c50f8fb4f37bcf5d419f0fd5f7b90d6037349d1957ea73cebbee"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_tahoe:   "f7cc12b6b91ff22fa812771f381b0ca12fde666eaa33fb2ee150cd46fa660993"
    sha256 cellar: :any, arm64_sequoia: "1ecf2b6b58aa4a52b1da74c990f40362737d5426a5f806decc972a4d5eba36ee"
    sha256 cellar: :any, arm64_sonoma:  "e6c73c2b595d9dcaeabf20b0de01d9cdd7530e2dbc443c43b5e23e4b009f98e1"
    sha256               x86_64_linux:  "1ad3ca8d0134c2ff67e3e4c6310f8427ca6f07f295580109a0c7e8ddedf3e77b"
  end

  depends_on "gcc@15" => :build

  depends_on "cddlib"
  depends_on "gmp"
  depends_on "tbb"

  patch :DATA

  def install
    linker_args = "-L#{Formula["cddlib"].lib} -static-libgcc -static-libstdc++"
    platform_link_args = "-L#{Formula["tbb"].lib} -ltbb"
    platform_link_args = "-rdynamic #{platform_link_args}" unless OS.mac?
    cxx_flags = "-I#{Formula["cddlib"].include}/cddlib"
    cxx_flags << " -D_64BITLONGINT" unless OS.mac?

    system "make", "PREFIX=#{Formula["gcc@15"].opt_bin}/", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "TBB_INCLUDEOPTIONS=-I#{Formula["tbb"].include}",
           "PLATFORM_LINKOPTIONS=#{platform_link_args}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG #{cxx_flags}",
           "cddpath=#{Formula["cddlib"].prefix}",
           "CC=#{Formula["gcc@15"].opt_bin}/gcc-15",
           "CXX=#{Formula["gcc@15"].opt_bin}/g++-15",
           "CLINKER=#{Formula["gcc@15"].opt_bin}/gcc-15",
           "CCLINKER=#{Formula["gcc@15"].opt_bin}/g++-15 #{linker_args}"
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
index 1d5fad9..29fb0f1 100644
--- a/Makefile
+++ b/Makefile
@@ -138,13 +138,12 @@ MKDIR=mkdir -p

 # PREFIX = /usr/local/gcc/6.2.0/bin/
 # PREFIX = /usr/local/gcc-8.1/bin/
-PREFIX =
 SHELL       = /bin/sh
 #ARCH        = LINUX

-CC          = $(PREFIX)gcc
+#CC          = $(PREFIX)gcc-15
 CLINKER     = $(CC)
-CXX         = $(PREFIX)g++
+#CXX         = $(PREFIX)g++-15
-CCLINKER    = $(CXX)
+#CCLINKER    = $(CXX)

 #CC          = $(PREFIX)gcc-8.1
diff --git a/src/field.h b/src/field.h
index 866be22..bc50a12 100644
--- a/src/field.h
+++ b/src/field.h
@@ -208,6 +208,7 @@ class FieldElementImplementation
   {
 	  fprintf(stderr,"*this is not in Z/pZ.\n");
 	  assert(0);
+	  return 0;
   }
   virtual bool isInteger()const
   {
@@ -223,6 +224,7 @@ class FieldElementImplementation
   Field& operator=(const Field& a)
     {
       assert(0);
+      return const_cast<Field&>(a);
     }//assignment
 };

@@ -271,6 +273,7 @@ class FieldImplementation
   virtual FieldElement random()
   {
 	  assert(0);
+	  return 0;
   }
     virtual int getCharacteristic()const=0;
     virtual const char *name()=0;
diff --git a/src/gfanlib_circuittableint.h b/src/gfanlib_circuittableint.h
index 6078a36..fdf4a36 100644
--- a/src/gfanlib_circuittableint.h
+++ b/src/gfanlib_circuittableint.h
@@ -27,7 +27,7 @@ namespace gfan{
   template<typename> struct MyMakeUnsigned;
   template <> struct MyMakeUnsigned<int32_t>{typedef uint32_t type;};
   template <> struct MyMakeUnsigned<int64_t>{typedef uint64_t type;};
-  template <> struct MyMakeUnsigned<__int128>{typedef unsigned __int128 type;};
+  template <> struct MyMakeUnsigned<__int128_t>{typedef __uint128_t type;};

   class MVMachineIntegerOverflow: public std::exception
 {
diff --git a/src/gfanlib_z.h b/src/gfanlib_z.h
index 2908d25..7e8c66f 100644
--- a/src/gfanlib_z.h
+++ b/src/gfanlib_z.h
@@ -9,6 +9,7 @@
 #define LIB_Z_H_

 #include <string.h>
+#include <cstdint>
 #include <ostream>
 #include <iostream>
 #include <cstdint>
--
2.53.0
