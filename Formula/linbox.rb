class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.1/linbox-1.7.1.tar.gz"
  sha256 "a2b5f910a54a46fa75b03f38ad603cae1afa973c95455813d85cf72c27553bd8"
  license "LGPL-2.1-or-later"
  revision 1

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "acd973169cd0f2454721ff48502c5faecd44c2f84d9ea6e93bee5f19d978fbf6"
    sha256 cellar: :any,                 arm64_sequoia: "d05a3a883c75b59a5ff98aac180a1c5a21c0c6d149d8a8f163b535dcc17684a8"
    sha256 cellar: :any,                 arm64_sonoma:  "abcabd37ea766bbfd996d694ec5c925092cbdc4ea35d29e883ebc0de2a43115a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6806d6ee9afc61c3a4ef674a612de2ff0f38fc224a722464225d3756b6f7439c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?

  # avoid type conversion errors
  patch do
    url "https://sources.debian.org/data/main/l/linbox/1.7.1-2/debian/patches/ntl-zz-px.patch"
    sha256 "c1f727d373cef5340ad51b188642a89ffdecbd6bc03ed4318a7e1b829c0cce9f"
  end

  def install
    ENV.cxx11
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OMPFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} -L#{libomp.opt_lib} -lomp"
    else
      ENV["OMPFLAGS"] = "-fopenmp"
    end
    ENV["CBLAS_LIBS"] = ENV["LIBS"] = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "autoreconf", "-vif"
    system "./configure",
           "--enable-openmp",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libomp = Formula["libomp"].opt_lib/"libomp.dylib"
      assert Utils.binary_linked_to_library?(lib/"liblinbox.dylib", libomp), "Missing linkage to libomp!"
    end
  end
end

__END__


diff --git a/build-aux/ltmain.sh b/build-aux/ltmain.sh
index 0cb7f90..1a42a33 100644
--- a/build-aux/ltmain.sh
+++ b/build-aux/ltmain.sh
@@ -6699,6 +6699,16 @@ func_mode_link ()
     # See if our shared archives depend on static archives.
     test -n "$old_archive_from_new_cmds" && build_old_libs=yes
 
+    # make sure "-Xpreprocessor -fopenmp" is processed as one token
+    case "$@" in
+    *-Xpreprocessor\ -fopenmp*)
+      fopenmp_match="-Xpreprocessor -fopenmp"
+      ;;
+    *)
+      fopenmp_match="-fopenmp"
+      ;;
+    esac
+
     # Go through the arguments, transforming them on the way.
     while test "$#" -gt 0; do
       arg=$1
@@ -7163,7 +7173,7 @@ func_mode_link ()
 	;;
 
       -mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe \
-      |-threads|-fopenmp|-openmp|-mp|-xopenmp|-omp|-qsmp=*)
+      |-threads|$fopenmp_match|fopenmp=*|-openmp|-mp|-xopenmp|-omp|-qsmp=*)
 	func_append compiler_flags " $arg"
 	func_append compile_command " $arg"
 	func_append finalize_command " $arg"
@@ -7706,7 +7716,7 @@ func_mode_link ()
 	found=false
 	case $deplib in
 	-mt|-mthreads|-kthread|-Kthread|-pthread|-pthreads|--thread-safe \
-        |-threads|-fopenmp|-openmp|-mp|-xopenmp|-omp|-qsmp=*)
+        |-threads|$fopenmp_match|fopenmp=*|-openmp|-mp|-xopenmp|-omp|-qsmp=*)
 	  if test prog,link = "$linkmode,$pass"; then
 	    compile_deplibs="$deplib $compile_deplibs"
 	    finalize_deplibs="$deplib $finalize_deplibs
