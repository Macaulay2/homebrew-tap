class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.6.2.tar.gz"
  sha256 "a674d5e5dc43634397de0d55dd5da3c32bd358d05f72b73a50e62c1a1686f10a"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/gfan-0.6.2_10"
    sha256 cellar: :any,                 arm64_monterey: "229e0358f1ebc66a7ad1c19c06bde99e15665a39cee27e60b59a4301e4f469c0"
    sha256 cellar: :any,                 arm64_ventura:  "15d153c34583bf3b10b86852fd4bac16e9d8fc12e524045a511472ec44350236"
    sha256 cellar: :any,                 big_sur:        "0ed20db484e5f69dcbe72a5a5c28c2d430733844ee6f9f541ddc8628e407a075"
    sha256 cellar: :any,                 catalina:       "49328ff1820ac2f7af1941e7e14825c0b54bee8c28727cb5c40287ba25d09587"
    sha256 cellar: :any,                 monterey:       "3cee4cd7b981c9001dba1a11da927869c2792e47094e1355737b2854a79ec501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab04196c4a20e443b7789943ab399774854b93976a4c3abfa31a8e08e1202d8"
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

  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/d51564127d757a3132684e9730f4085cb89297bb/M2/libraries/gfan/patch-0.6.2"
    sha256 "9ebbf25e6de16baec877050bef69c85504e7bfa81e79407c2ab00ea4433e838c"
  end

  patch :DATA

  def install
    system "make", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG -I#{Formula["cddlib"].include}/cddlib",
           "CCLINKER=#{ENV.cxx} -L#{Formula["cddlib"].lib}"
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
