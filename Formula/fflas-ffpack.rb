class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/linbox-team/fflas-ffpack/releases/download/v2.5.0/fflas-ffpack-2.5.0.tar.gz"
  sha256 "dafb4c0835824d28e4f823748579be6e4c8889c9570c6ce9cce1e186c3ebbb23"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/fflas-ffpack.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c8eaf4b6df9eb77de2bdf440074c5f66637daa7ddfed268769544db60f1e867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1280e2d7cb7fb0a144dfcc2af29023d861bde51bb198b246bfa03793ad7aabc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276f1bc934328c848c25812fa5dc0308deb4eff70e9bd89dce2f6630ddabf67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f08ed61fcd8b4511512887fea26d4fe17906e083159e058109574a0b66450d7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  patch :DATA

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
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      libomp = Formula["libomp"].opt_lib/"libomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libm4ri.dylib", libgomp), "Unwanted linkage to libgomp!"
      assert Utils.binary_linked_to_library?(lib/"libm4ri.dylib", libomp), "Missing linkage to libomp!"
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
 	    finalize_deplibs="$deplib $finalize_deplibs"
