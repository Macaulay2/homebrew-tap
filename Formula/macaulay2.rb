class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 2

  stable do
    url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.22.tar.gz"
    sha256 "fededb82203d93f3f6db22db97350407fc6e55e90285cc8fa89713ff21d5c0fc"
    patch :DATA
    patch do
      url "https://github.com/Macaulay2/M2/commit/84c7b9f67bfdb6b821e24546ab2dd4e2455dfdbf.patch?full_index=1"
      sha256 "135100251be6c1217948c74c46761d7550ed30e4dc27cce6a76a45d34a362f78"
    end
  end

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.22_2"
    sha256 cellar: :any, ventura:      "6f520730827d921b2f05719c43f5d260968490ab73b2240d99cc79f0a8d408b9"
    sha256 cellar: :any, monterey:     "76b58eacb443edb17bada3e108a8e42f568130ffe06d662ee11c4a1d767c6507"
    sha256               x86_64_linux: "3e64bb7cf1677029e5374c172c81b6a8b556e762d6d3f2c3465a4c9706414f02"
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

diff --git a/M2/Macaulay2/e/CMakeLists.txt b/M2/Macaulay2/e/CMakeLists.txt
index ce702082fe..bd23b68304 100644
--- a/M2/Macaulay2/e/CMakeLists.txt
+++ b/M2/Macaulay2/e/CMakeLists.txt
@@ -359,10 +359,6 @@ if(EIGEN3_FOUND)
   target_link_libraries(M2-engine PUBLIC Eigen3::Eigen)
 endif()
 
-if(OpenMP_FOUND)
-  target_link_libraries(M2-engine PUBLIC OpenMP::OpenMP_CXX)
-endif()
-
 # Compiler warning flags
 target_compile_options(M2-engine PRIVATE
   -Wno-cast-qual # FIXME
-- 
2.40.1

diff --git a/M2/Macaulay2/e/eigen.cpp b/M2/Macaulay2/e/eigen.cpp
index 26cf19de66..77748d5a8c 100644
--- a/M2/Macaulay2/e/eigen.cpp
+++ b/M2/Macaulay2/e/eigen.cpp
@@ -29,6 +29,41 @@ using MatrixXmpRR = Eigen::Matrix<double,Eigen::Dynamic,Eigen::Dynamic>;
 using MatrixXmpCC = Eigen::Matrix<std::complex<double>,Eigen::Dynamic,Eigen::Dynamic>;
 #endif
 
+#ifdef _LIBCPP_VERSION
+/* workaround incompatibility between libc++'s implementation of complex and
+ * mpreal
+ */
+namespace eigen_mpfr {
+inline Real abs(const Complex &x) { return hypot(x.real(), x.imag()); }
+inline Complex sqrt(const Complex &x)
+{
+  Real a = abs(x);
+  const Real &xr = x.real();
+  const Real &xi = x.imag();
+  if (xi >= 0) { return Complex(sqrt((a + xr) / 2), sqrt((a - xr) / 2)); }
+  else { return Complex(sqrt((a + xr) / 2), -sqrt((a - xr) / 2)); }
+}
+inline std::complex<Real> operator/(const Complex &lhs, const Complex &rhs)
+{
+  const Real &lhsr = lhs.real();
+  const Real &lhsi = lhs.imag();
+  const Real &rhsr = rhs.real();
+  const Real &rhsi = rhs.imag();
+  Real normrhs = rhsr*rhsr+rhsi*rhsi;
+  return Complex((lhsr * rhsr + lhsi * rhsi) / normrhs,
+                 (lhsi * rhsr - lhsr * rhsi) / normrhs);
+}
+inline std::complex<Real> operator*(const Complex &lhs, const Complex &rhs)
+{
+  const Real &lhsr = lhs.real();
+  const Real &lhsi = lhs.imag();
+  const Real &rhsr = rhs.real();
+  const Real &rhsi = rhs.imag();
+  return Complex(lhsr * rhsr - lhsi * rhsi, lhsi * rhsr + lhsr * rhsi);
+}
+};  // namespace eigen_mpfr
+#endif
+
 namespace EigenM2 {
 
 #ifdef NO_LAPACK
--
2.40.1
