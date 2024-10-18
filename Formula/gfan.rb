class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.7.tar.gz"
  sha256 "ab833757e1e4d4a98662f4aa691394013ea9a226f6416b8f8565356d6fcc989e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sonoma: "f4aa20c4b49233a6c8a68e1a751b783169797764a157d5745f73f8228c41fb62"
    sha256 cellar: :any,                 ventura:      "aa24a98686efeb52abe9fd8c27d5d1a888c9e86303c0e53eec539ee8c195a57c"
    sha256 cellar: :any,                 monterey:     "b92b36b01d8a2187313467b37b21793e34a89e5edd78207e685e8e0e99f23182"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ad2d53e029a178bd88ba7837fd216ea7b5b46f77648a034a5c7421cfb371555"
  end

  if OS.mac?
    depends_on "gcc" => :build
    fails_with :clang
  else
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cddlib"
  depends_on "gmp"

  patch :DATA

  def install
    linker_args = "#{ENV.cxx} -L#{Formula["cddlib"].lib} "
    linker_args << "-static-libgcc -static-libstdc++ "
    linker_args << "-ld_classic" if OS.mac? && DevelopmentTools.clang_build_version >= 1500

    system "make", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG -I#{Formula["cddlib"].include}/cddlib",
           "CCLINKER=#{linker_args}"
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
index 67c8164..0c9bbf2 100644
--- a/Makefile
+++ b/Makefile
@@ -117,11 +117,6 @@ PREFIX =
 SHELL       = /bin/sh
 #ARCH        = LINUX
 
-CC          = $(PREFIX)gcc
-CLINKER     = $(CC)
-CXX         = $(PREFIX)g++
-CCLINKER    = $(CXX)
-
 #CC          = $(PREFIX)gcc-8.1
 #CLINKER     = $(CC)
 #CXX         = $(PREFIX)g++-8.1
@@ -420,9 +415,9 @@ EXECS	  = $(MAIN)
 # (compiling with gcc version 4.7.2 and running gfan _tropicaltraverse on a starting cone for Grassmann3_7)
 # Either this is a bug in the code or in the compiler. The bug disappears by compiling with -fno-guess-branch-probability
 src/symmetrictraversal.o: src/symmetrictraversal.cpp
-	$(CXX) $(CFLAGS) -fno-guess-branch-probability  -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
+#	$(CXX) $(CFLAGS) -fno-guess-branch-probability  -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
 # If compiling with clang, use the line below instead:
-#	$(CXX) $(CFLAGS) -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
+	$(CXX) $(CFLAGS) -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
 
 # Define suffixes to make the program compile on legolas.imf.au.dk :
 .SUFFIXES: .o .cpp .c
diff --git a/src/timer.cpp b/src/timer.cpp
index 7421c41..b5d8741 100644
--- a/src/timer.cpp
+++ b/src/timer.cpp
@@ -1,10 +1,10 @@
 #include "timer.h"
-#include "log.h"
-
 #include "iostream"
 #include <time.h>
 #include <assert.h>
 
+#include "log.h" // include last, because it defines a macro "log2" also defined as a function in math.h
+
 using namespace std;
 
 Timer* Timer::timers;
-- 
2.46.0
