class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 3

  stable do
    url "https://github.com/Macaulay2/M2/archive/release-1.19.1.tar.gz"
    sha256 "35d87b280157e1485e7fc05f5192a4db4d69d0463d58c326a3f3814127f6c527"
    patch :DATA
  end

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.19.1_2"
    sha256 cellar: :any, big_sur:      "05d927fd25c69591ad19aaefb8d2cdc1f24c16fb3b5c7da80560ee911208c729"
    sha256 cellar: :any, catalina:     "ea722c8b1637513522d72753da02b84511729392aa9cc787072e2ac4722a289f"
    sha256               x86_64_linux: "65169c84db0e3e632d5b70971e2d9213f8c928569b3a75e14888ca1ca49f5108"
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
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  # temporary, until problems with boost 1.78 are resolved
  # see https://github.com/Macaulay2/homebrew-tap/pull/131#issuecomment-1047358601
  depends_on "boost@1.76"
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
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?
  depends_on "readline"
  depends_on "tbb@2020"

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
    system "git", "-C", "M2/submodules/mathicgb", "checkout", "14cb3196066af7ef63857c3b44f19b73f31371b8"

    # Prefix paths for dependencies
    lib_prefix = deps.map { |lib| Formula[lib.name].prefix }.join(";")

    args = std_cmake_args
    args << "-DBUILD_NATIVE=OFF"
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=#{lib_prefix}"
    args << "-DTBB_ROOT_DIR=#{Formula["tbb@2020"].prefix}"
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
    # system "#{bin}/M2", "--check", "2", "-e", "exit 0"
  end
end

__END__

diff --git a/M2/Macaulay2/packages/Macaulay2Doc/changes.m2 b/M2/Macaulay2/packages/Macaulay2Doc/changes.m2
index 2ab88b234b..988a95d6aa 100644
--- a/M2/Macaulay2/packages/Macaulay2Doc/changes.m2
+++ b/M2/Macaulay2/packages/Macaulay2Doc/changes.m2
@@ -6,7 +6,6 @@ document {
      Key => "changes to Macaulay2, by version",
      Subnodes => {
 	  TO "changes made for the next release",
-	  TO "changes, 1.19.1",
 	  TO "changes, 1.19",
 	  TO "changes, 1.18",
 	  TO "changes, 1.17",
@@ -39,18 +38,6 @@ document {
      Key => "changes made for the next release"
      }
 
-document {
-     Key => "changes, 1.19.1",
-     UL {
-          LI { "bugs fixed:",
-	       UL {
-		    LI { "repaired two broken links to packages in the changes documentation" },
-		    LI { "restored the 'Ways to use' and 'For the programmer' sections of the documentation provided by ", TO "help", " for a method function." }
-		    }
-	       }
-     	  }
-     }
-
 document {
      Key => "changes, 1.19",
      UL {
-- 
2.31.1
