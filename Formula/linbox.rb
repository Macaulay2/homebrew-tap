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
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "1ae771deb679e6acca1fbfd522de6cdf34b2defdcb8b55ae71ac2966f5de753d"
    sha256 cellar: :any, arm64_sequoia: "522f57c22dfe363400064a068918f6378279f1a1df055205f1ab99ac585f8d8e"
    sha256 cellar: :any, arm64_sonoma:  "51a077402ccd55fcf08d90b02dbf42411d40e08923cbc2af6b72e228b3d517d4"
    sha256 cellar: :any, x86_64_linux:  "e95adebb52365b4b10dc75887c4809ed08aeb727d70e5e9eb5bc4cd76d66a646"
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
      libomp = formula_opt_lib("libomp")/"libomp.dylib"
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
