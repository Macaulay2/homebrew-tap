class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  version "1.22-rc1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  stable do
    url "https://github.com/Macaulay2/M2/archive/refs/heads/pre-master.tar.gz"
    sha256 "9de12885223d002b86479595fb31e5a4cfdb2bbbdebdda542ca8cd996fb30f3a"
    patch :DATA
  end

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.22-rc1"
    sha256 cellar: :any, arm64_ventura: "465c7af8301da7dddf2d4ee86b6632c3c9715d9df173a5098965c8b8e1ba547e"
    sha256 cellar: :any, ventura:       "970ed1d8d60254ce2c0fa9fc133e7dcb422a8c055e0488c4e3d18d7c9421069f"
    sha256 cellar: :any, monterey:      "9f861038eec762f006360b0358ed2b307cf2d55a27b7b1a3977ab76f19351b8b"
    sha256 cellar: :any, big_sur:       "511f4bd73d177fa08f60fde56bc202cdd1df866e620aca7fbdf7f6f02d6a6dac"
    sha256               x86_64_linux:  "2cf33a26f8f1af9c79590515ae3aab6a12b66891c3f3bd78f0525ebc1fc91eda"
  end

  head do
    url "https://github.com/Macaulay2/M2/archive/refs/heads/master.tar.gz"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "npm" => :build
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
  depends_on "libatomic_ops"
  depends_on "libxml2" unless OS.mac?
  depends_on "libffi"
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
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
  depends_on "python@3.10" => :recommended
  depends_on "topcom" => :recommended

  def install
    # Only for release candidate
    inreplace "M2/VERSION", "1.21", "1.22"

    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/ForeignFunctions.m2", "get \"!brew --prefix\"", "getenv \"HOMEBREW_PREFIX\""

    # c.f. https://github.com/Macaulay2/M2/issues/2682
    inreplace "M2/Macaulay2/d/CMakeLists.txt", "M2-supervisor", "M2-supervisor quadmath" unless OS.mac?

    # Place the submodules, since the tarfile doesn't include them
    system "git", "clone", "https://github.com/Macaulay2/M2-emacs.git", "M2/Macaulay2/editors/emacs",
           "--branch", "main"
    system "git", "clone", "https://github.com/Macaulay2/memtailor.git", "M2/submodules/memtailor"
    system "git", "clone", "https://github.com/Macaulay2/mathic.git", "M2/submodules/mathic"
    system "git", "clone", "https://github.com/Macaulay2/mathicgb.git", "M2/submodules/mathicgb"

    # Prefix paths for dependencies
    lib_prefix = deps.map { |lib| Formula[lib.name].prefix }.join(";")

    args = std_cmake_args
    args << "-DBUILD_NATIVE=OFF"
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=#{lib_prefix}"
    args << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}"
    args << "-DWITH_OMP=ON" if build.with?("libomp") || !OS.mac?

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    build_path = "M2/BUILD/build-brew"
    system "cmake", "-GNinja", "-SM2", "-B#{build_path}", *args
    system "cmake", "--build", build_path, "--target", "M2-core", "M2-emacs", "M2-highlightjs"
    system "cmake", "--build", build_path, "--target", "install-Macaulay2Doc"
    system "cmake", "--build", build_path, "--target", "install-packages" unless head?
    system "cmake", "--install", build_path
  end

  test do
    system "#{bin}/M2", "--version"
    system "#{bin}/M2", "--check", "1", "-e", "exit 0"
    # system "#{bin}/M2", "--check", "2", "-e", "exit 0"
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
index ca3effff15..45e6b11c81 100644
--- a/M2/cmake/check-libraries.cmake
+++ b/M2/cmake/check-libraries.cmake
@@ -43,6 +43,8 @@ endif()
 
 find_package(Threads	REQUIRED QUIET)
 find_package(LAPACK	REQUIRED QUIET)
+
+set(Boost_USE_STATIC_LIBS ON)
 find_package(Boost	REQUIRED QUIET COMPONENTS regex OPTIONAL_COMPONENTS stacktrace_backtrace stacktrace_addr2line)
 if(Boost_STACKTRACE_BACKTRACE_FOUND)
   set(Boost_stacktrace_lib "Boost::stacktrace_backtrace")
-- 
2.38.1

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

diff --git a/M2/cmake/check-libraries.cmake b/M2/cmake/check-libraries.cmake
index b10dce3c6d..25344274e4 100644
--- a/M2/cmake/check-libraries.cmake
+++ b/M2/cmake/check-libraries.cmake
@@ -73,6 +73,8 @@ foreach(lang IN ITEMS C CXX)
     string(REGEX REPLACE "^lib" "" _lib "${_lib}")
     set(OpenMP_${lang}_LDLIBS "${OpenMP_${lang}_LDLIBS} -L${_libdir} -Wl,-rpath,${_libdir} -l${_lib}")
   endforeach()
+  # TODO: remove when https://gitlab.kitware.com/cmake/cmake/-/issues/24966 is fixed
+  set_property(TARGET OpenMP::OpenMP_${lang} PROPERTY INTERFACE_LINK_OPTIONS "SHELL: ${OpenMP_${lang}_FLAGS}")
 endforeach()
 
 if(WITH_TBB)
-- 
2.40.1

