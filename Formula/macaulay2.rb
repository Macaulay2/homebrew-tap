class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 5

  stable do
    url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.20.tar.gz"
    sha256 "38c36a8a91759b71eff2aad4a5075fff0edf439b54a0d97cc34bd5b92d2a34b0"
    patch :DATA
  end

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.20_5"
    sha256 cellar: :any,                 arm64_monterey: "8b084b22d65ff52b935a96a5b3730e66796046ff22097b486afaf7d60651e917"
    sha256 cellar: :any,                 big_sur:        "9cb8f51edbc0429837deeb07b4278d528f521f7843b3a5bbc28e0713231ae40f"
    sha256 cellar: :any,                 catalina:       "f1a528ff19200a8af615868c4bc8a2c6d698ba55cc64b42f4ceae6aeee1602d2"
    sha256                               x86_64_linux:   "1253b62ac356a2beafc714c8cfec56ef49e777c2dda43d63c90114eb0a1ceeae"
  end

  head do
    url "https://github.com/Macaulay2/M2/archive/refs/heads/master.tar.gz"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
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
  depends_on "topcom" => :recommended

  def install
    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

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

diff --git a/M2/Macaulay2/e/aring-zzp-ffpack.hpp b/M2/Macaulay2/e/aring-zzp-ffpack.hpp
index 6640d39e9..0c6284700 100644
--- a/M2/Macaulay2/e/aring-zzp-ffpack.hpp
+++ b/M2/Macaulay2/e/aring-zzp-ffpack.hpp
@@ -9,6 +9,7 @@
 
 #include <type_traits> // define bool_constant to fix issue #2347
 #include <utility>
+#include <ratio> //fix compilation errors on some macs
 
 #pragma GCC diagnostic push
 #pragma GCC diagnostic ignored "-Wconversion"
-- 
2.36.1
