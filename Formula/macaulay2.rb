class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  # when bumping to a new release, also update the submodule commits below
  url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.26.11.tar.gz"
  sha256 "fdb1a2e7b675de9baa8f2cb0851d156d96b9bca9e6362ba094b30c5d911bce3e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  head "https://github.com/Macaulay2/M2/archive/refs/heads/development.tar.gz"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    manifest_sha256 "a1278be2901cb4039b87fd6ff377c834eb6690c7413ccb6d814ef7c8862caf5c"
    sha256 cellar: :any, arm64_golden_gate: "b18973a7859d88e0cafcdc710564b948abb48cc86ad832d1d7c5d7dd9959dfa8"
    sha256 cellar: :any, arm64_tahoe:       "db32b8bc892b7a911dd776bd3011f156bbdc1b4c8b61ce944c7b4cada89a0b3f"
    sha256 cellar: :any, arm64_sequoia:     "709535d7988a94d054aa92ca168509402461d596f177330e4b5a3aa3efc5e46e"
    sha256 cellar: :any, arm64_linux:       "541be740f2ebc402e4ed8093127b8f813fc837511d98fe016dd5a86ac6624ea3"
    sha256 cellar: :any, x86_64_linux:      "fd831e15021e63d01499d4045932fd35083b1a1b666d4246f3e16c488656b81a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "frobby"
  depends_on "gdbm"
  depends_on "givaro"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libffi"
  depends_on "libomp" if OS.mac?
  depends_on "macaulay2/tap/factory"
  depends_on "libxml2" unless OS.mac?
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "nauty"
  depends_on "normaliz"
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?
  depends_on "palp"
  depends_on "python@3.15" # brew linkage --test expects specific version
  depends_on "readline"
  depends_on "tbb"

  depends_on "cohomcalg" => :recommended
  depends_on "csdp" => :recommended
  depends_on "fourtitwo" => :recommended
  depends_on "gfan" => :recommended
  depends_on "lrs" => :recommended
  depends_on "msolve" => :recommended
  depends_on "topcom" => :recommended

  patch :DATA

  def git_clone_at_commit(url, dir, commit)
    system "git", "clone", url, dir
    cd dir do
      system "git", "checkout", commit
    end
  end

  def install
    # Build documentation without launching X11 programs such as xterm.
    ENV.delete("DISPLAY")

    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    # Don't rely on brew being in PATH (not during build or in Emacs on macOS)
    inreplace "M2/Macaulay2/packages/ForeignFunctions.m2", "get \"!brew --prefix\"", "\"#{HOMEBREW_PREFIX}\""

    # Upstream links quadmath on non-macOS systems, but ARM64 Linux has no libquadmath.
    if OS.linux? && Hardware::CPU.arm?
      inreplace "M2/Macaulay2/d/CMakeLists.txt",
                "target_link_libraries(M2-interpreter PRIVATE quadmath)", ""
    end

    # Place the submodules, since the tarfile doesn't include them
    git_clone_at_commit(
      "https://github.com/Macaulay2/M2-emacs.git",
      "M2/Macaulay2/editors/emacs",
      "aeac7105993337648eae572d2f8fbec3d4aeeaca",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/memtailor.git",
      "M2/submodules/memtailor",
      "6d7da631b50eeb20218d701f5ebad7bbeb54e71a",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathic.git",
      "M2/submodules/mathic",
      "62fe3187b25d3d9bfcf54530c74797db8d2c238a",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathicgb.git",
      "M2/submodules/mathicgb",
      "31cec23f892389bcbb8c15b821764b8b61963824",
    )

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
index 617dac19fa..9d560febc6 100644
--- a/M2/Macaulay2/m2/packages.m2
+++ b/M2/Macaulay2/m2/packages.m2
@@ -225,7 +225,6 @@ needsPackage String  := opts -> pkgname -> (
     and instance(pkg := value PackageDictionary#pkgname, Package)
     and (opts.FileName === null or
 	realpath opts.FileName == realpath pkg#"source file")
-    and pkg.PackageIsLoaded
     then (
 	if any(packageFiles pkg, file -> fileTime file > filesLoaded#file)
 	then loadPackage(pkgname, opts ++ {Reload => true})
-- 
2.43.0

diff --git a/M2/Macaulay2/packages/Topcom.m2 b/M2/Macaulay2/packages/Topcom.m2
index 52af3a2c69..6ffbef38a6 100644
--- a/M2/Macaulay2/packages/Topcom.m2
+++ b/M2/Macaulay2/packages/Topcom.m2
@@ -342,7 +342,7 @@ topcomIsTriangulation(Matrix, List) := Boolean => opts -> (Vin, T) -> (
       << "Index sets do not correspond to full-dimensional simplices" << endl;
       return false;
    );
-   (outfile, errfile) := callTopcom("points2nflips --checktriang -v", {topcomPoints(V, Homogenize=>false), [], T });
+   (outfile, errfile) := callTopcom("points2nflips --checktriang --memopt -v", {topcomPoints(V, Homogenize=>false), [], T });
    not match("not valid", get errfile)
 )
 
-- 
2.43.0
