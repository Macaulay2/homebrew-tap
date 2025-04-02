class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.24.11.tar.gz"
  sha256 "6a0b4dfbb340d3ea71c8190b31fc806de76a2dcda458195f8aed4e3ef0d8be5d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  head "https://github.com/Macaulay2/M2/archive/refs/heads/development.tar.gz"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "eigen"
  depends_on "factory"
  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "frobby"
  depends_on "gdbm"
  depends_on "givaro"
  depends_on "gmp"
  depends_on "libxml2" unless OS.mac?
  depends_on "libffi"
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "msolve"
  depends_on "node"
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?
  depends_on "readline"
  depends_on "tbb"

  depends_on "cohomcalg" => :recommended
  depends_on "csdp" => :recommended
  depends_on "fourtitwo" => :recommended
  depends_on "gfan" => :recommended
  depends_on "libomp" => :recommended if OS.mac?
  depends_on "lrs" => :recommended
  depends_on "nauty" => :recommended
  depends_on "normaliz" => :recommended
  depends_on "python" => :recommended
  depends_on "topcom" => :recommended

  # patch for flint 3.2.0; remove on next release
  patch do
    url "https://github.com/Macaulay2/M2/commit/c80d102ed88732ca76cd40a35807a678b8af99fb.patch?full_index=1"
    sha256 "d9754b2f6b4650cedcd0d9f50c8ba83604919c195d9e7265cef557fd26db38c0"
  end

  patch :DATA

  def install
    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/ForeignFunctions.m2", "get \"!brew --prefix\"", "getenv \"HOMEBREW_PREFIX\""

    # c.f. https://github.com/Macaulay2/M2/issues/2682
    inreplace "M2/Macaulay2/d/CMakeLists.txt", "M2-supervisor", "M2-supervisor quadmath" unless OS.mac?

    # Place the submodules, since the tarfile doesn't include them
    system "git", "clone", "https://github.com/Macaulay2/M2-emacs.git", "M2/Macaulay2/editors/emacs"
    system "git", "clone", "https://github.com/Macaulay2/memtailor.git", "M2/submodules/memtailor"
    system "git", "clone", "https://github.com/Macaulay2/mathic.git", "M2/submodules/mathic"
    system "git", "clone", "https://github.com/Macaulay2/mathicgb.git", "M2/submodules/mathicgb"

    # Prefix paths for dependencies
    lib_prefix = deps.map { |lib| Formula[lib.name].prefix }.join(";")
    boost_stacktrace_path = "#{Formula["boost"].lib}/cmake/boost_stacktrace_backtrace"
    boost_version = Formula["boost"].version

    args = std_cmake_args
    args << "-DBUILD_NATIVE=OFF"
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=#{lib_prefix}"
    args << "-Dboost_stacktrace_backtrace_DIR=#{boost_stacktrace_path}-#{boost_version}/"
    args << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}"
    args << "-DWITH_OMP=ON" if build.with?("libomp") || !OS.mac?

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    build_path = "M2/BUILD/build-brew"
    system "cmake", "-GNinja", "-SM2", "-B#{build_path}", *args
    system "cmake", "--build", build_path, "--target", "M2-core", "M2-emacs"
    system "cmake", "--build", build_path, "--target", "install-Macaulay2Doc"
    system "cmake", "--build", build_path, "--target", "install-packages" unless head?
    system "cmake", "--install", build_path
  end

  test do
    system "#{bin}/M2", "--version"
    system "#{bin}/M2", "--check", "1", "-e", "exit 0"
    # seems to fail if the tests take longer than 5min
    # system "#{bin}/M2", "--check", "2", "-e", "exit 0"
    # system "#{bin}/M2", "--check", "3", "-e", "exit 0"
  end
end

__END__

diff --git a/M2/Macaulay2/m2/packages.m2 b/M2/Macaulay2/m2/packages.m2
index d5ddc33bc..92f700b5c 100644
--- a/M2/Macaulay2/m2/packages.m2
+++ b/M2/Macaulay2/m2/packages.m2
@@ -188,7 +188,6 @@ needsPackage String  := opts -> pkgname -> (
     and instance(pkg := value PackageDictionary#pkgname, Package)
     and (opts.FileName === null or
 	realpath opts.FileName == realpath pkg#"source file")
-    and pkg.PackageIsLoaded
     then use value PackageDictionary#pkgname
     else loadPackage(pkgname, opts))

-- 
2.34.3

diff --git a/M2/cmake/check-libraries.cmake b/M2/cmake/check-libraries.cmake
index c39b27247d..0ab5d93f28 100644
--- a/M2/cmake/check-libraries.cmake
+++ b/M2/cmake/check-libraries.cmake
@@ -42,7 +42,14 @@ endif()

 find_package(Threads	REQUIRED QUIET)
 find_package(LAPACK	REQUIRED QUIET)
-find_package(Boost	REQUIRED QUIET COMPONENTS regex OPTIONAL_COMPONENTS stacktrace_backtrace stacktrace_addr2line)
+
+set(Boost_USE_STATIC_LIBS ON)
+if(UNIX)
+  cmake_policy(SET CMP0167 OLD) # load CMake's FindBoost module
+  find_package(Boost	REQUIRED QUIET COMPONENTS regex OPTIONAL_COMPONENTS stacktrace_addr2line)
+else()
+  find_package(Boost	REQUIRED QUIET COMPONENTS regex OPTIONAL_COMPONENTS stacktrace_backtrace)
+endif()
 if(Boost_STACKTRACE_BACKTRACE_FOUND)
   set(Boost_stacktrace_lib "Boost::stacktrace_backtrace")
 elseif(Boost_STACKTRACE_ADDR2LINE_FOUND)
--
2.49.0

diff --git a/M2/Macaulay2/packages/Topcom.m2 b/M2/Macaulay2/packages/Topcom.m2
index 15832adfb1..e9af682733 100644
--- a/M2/Macaulay2/packages/Topcom.m2
+++ b/M2/Macaulay2/packages/Topcom.m2
@@ -317,7 +317,7 @@ topcomIsTriangulation(Matrix, List) := Boolean => opts -> (Vin, T) -> (
       << "Index sets do not correspond to full-dimensional simplices" << endl;
       return false;
    );
-   (outfile, errfile) := callTopcom("points2nflips --checktriang -v", {topcomPoints(V, Homogenize=>false), [], T });
+   (outfile, errfile) := callTopcom("points2nflips --checktriang --memopt -v", {topcomPoints(V, Homogenize=>false), [], T });
    not match("not valid", get errfile)
 )
 
-- 
2.38.1

diff --git a/M2/Macaulay2/d/CMakeLists.txt b/M2/Macaulay2/d/CMakeLists.txt
index 9114704d79..65983c2fcd 100644
--- a/M2/Macaulay2/d/CMakeLists.txt
+++ b/M2/Macaulay2/d/CMakeLists.txt
@@ -146,7 +146,8 @@ add_library(M2-interpreter OBJECT ${CLIST} ${CXXLIST} ${TAGS}
   $<$<BOOL:${WITH_XML}>:xml-c.c xml-c.h>
   $<$<BOOL:${WITH_PYTHON}>:python-c.c>)

-target_link_libraries(M2-interpreter PRIVATE M2-supervisor Boost::regex
+target_link_libraries(M2-interpreter PRIVATE M2-supervisor
+  Boost::boost # boost_regex is now header-only, so we don't link Boost::regex
   $<$<BOOL:${WITH_TBB}>:TBB::tbb>
   $<$<BOOL:${WITH_FFI}>:FFI::ffi>)
 
-- 
2.48.1
