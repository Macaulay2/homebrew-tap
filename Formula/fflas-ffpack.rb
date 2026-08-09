class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/linbox-team/fflas-ffpack/releases/download/v2.5.0/fflas-ffpack-2.5.0.tar.gz"
  sha256 "dafb4c0835824d28e4f823748579be6e4c8889c9570c6ce9cce1e186c3ebbb23"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/fflas-ffpack.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 5
    sha256 cellar: :any, arm64_tahoe:   "10bfa1299d79783e4ea723e749d2d83d31e3b4e087784c4de0b167720ef30c3b"
    sha256 cellar: :any, arm64_sequoia: "a78ed087effdfede1a3fbdfc67842edf4f35f00cd1e3c9ee6771581d12a33d18"
    sha256 cellar: :any, arm64_sonoma:  "d73c52e7e381b07dc6422cd6cc61edf2532e955bb9e75a9294436da71de0ac50"
    sha256 cellar: :any, sequoia:       "275b4175d0b17c62be56c509b7d33f959eea5f119d860df397c6c3c10a77fccf"
    sha256 cellar: :any, x86_64_linux:  "c709ef017a277e5020adaa05b7b8fe96239f0f256a349e6e96a1dd70c0ffc05a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  # Link Givaro and BLAS directly into all precompiled libraries.  Only
  # libfflas listed $(GIVARO_LIBS); libffpack, libfflas_c and libffpack_c
  # relied on reaching Givaro through it, which libtool does not propagate,
  # so libfflas_c fails to link on macOS.  Reported upstream as
  # linbox-team/fflas-ffpack#391.
  patch do
    url "https://github.com/linbox-team/fflas-ffpack/commit/9391c9422424d47d6b6d0c02a1af72fd2ee97a0f.patch?full_index=1"
    sha256 "067339896c4e99e5b47873caca5a952d28dae3068da48f9faa72697ba17ec0d3"
  end

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
           "--prefix=#{prefix}",
           "--enable-precompilation"
    system "make", "install"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libomp = formula_opt_lib("libomp")/"libomp.dylib"
      assert Utils.binary_linked_to_library?(lib/"libfflas.dylib", libomp), "Missing linkage to libomp!"
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
