class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.6.2.tar.gz"
  sha256 "a674d5e5dc43634397de0d55dd5da3c32bd358d05f72b73a50e62c1a1686f10a"
  license "GPL-2.0-or-later"
  revision 9

  if OS.mac?
    depends_on "gcc"
    fails_with :clang
  else
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cddlib@0.94m"
  depends_on "gmp"

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/d51564127d757a3132684e9730f4085cb89297bb/M2/libraries/gfan/patch-0.6.2"
    sha256 "9ebbf25e6de16baec877050bef69c85504e7bfa81e79407c2ab00ea4433e838c"
  end

  patch :DATA

  def install
    system "make", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG -I#{Formula["cddlib@0.94m"].include}/cddlib",
           "CCLINKER=#{ENV.cxx} -L#{Formula["cddlib@0.94m"].lib}"
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

diff --git a/Makefile-orig b/Makefile
index 737208abfb..52e010e0b3 100644
--- a/Makefile
+++ b/Makefile
@@ -110,15 +110,15 @@ MKDIR=mkdir -p
 PREFIX =
 SHELL       = /bin/sh
 #ARCH        = LINUX
-CC          = $(PREFIX)gcc
-CLINKER     = $(CC)
-CXX         = $(PREFIX)g++
-CCLINKER    = $(CXX)
+#CC          = $(PREFIX)gcc
+#CLINKER     = $(CC)
+#CXX         = $(PREFIX)g++
+#CCLINKER    = $(CXX)
 #OPTFLAGS    = -O2 -DGMPRATIONAL -DNDEBUG
 # Note that gcc produces wrong code with -O3
-OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O2	 #-O3 -fno-guess-branch-probability #-DNDEBUG
+#OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O2	 #-O3 -fno-guess-branch-probability #-DNDEBUG
 #OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O3 -mavx -msse2  -finline-limit=1000 -ffast-math -Wuninitialized # -fno-guess-branch-probability #-DNDEBUG -ftree-vectorizer-verbose=2
-#OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O1             -fno-guess-branch-probability
+OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O1             -fno-guess-branch-probability
  #-DNDEBUG
 #OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O3 -mavx -msse2 -ftree-vectorizer-verbose=2 -finline-limit=1000 -ffast-math #-DNDEBUG
 #OPTFLAGS    =  -DGMPRATIONAL -Wuninitialized -fno-omit-frame-pointer -O3 -mavx -msse2 -ftree-vectorizer-verbose=2 -march=native -unroll-loops --param max-unroll-times=4 -ffast-math #-DNDEBUG
-- 
2.31.1
