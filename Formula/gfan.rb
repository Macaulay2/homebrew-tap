class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.6.2.tar.gz"
  sha256 "a674d5e5dc43634397de0d55dd5da3c32bd358d05f72b73a50e62c1a1686f10a"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/gfan-0.6.2_2"
    cellar :any
    sha256 "c5b2e0afafa57fe3bdbab68efa8de8cbb62cc3b6321c3a25d88f21165f42fcbe" => :catalina
    sha256 "e1042c120fe9535956872f4427dbb3d6deeba5d2c79079421f31b0bd03bd0cc2" => :x86_64_linux
  end

  if OS.mac?
    depends_on "llvm" => :build
    fails_with :clang
  else
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cddlib@0.94k"
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
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG -I#{Formula["cddlib@0.94k"].include}/cddlib",
           "CCLINKER=#{ENV.cxx} -L#{Formula["cddlib@0.94k"].lib}"
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
index 737208a..a49b4ed 100644
--- a/Makefile
+++ b/Makefile
@@ -110,9 +110,9 @@ MKDIR=mkdir -p
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
