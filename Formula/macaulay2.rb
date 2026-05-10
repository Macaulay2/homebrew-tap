class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  # when bumping to a new release, also update the submodule commits below
  url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.26.05.tar.gz"
  sha256 "ed3862b635bf6ea30b9de58890ed7024f576ba4014e3553949c1dcb2f46175d5"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  head "https://github.com/Macaulay2/M2/archive/refs/heads/development.tar.gz"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_tahoe:   "92f21cd21a65134d7d7f6640737d4f6ed394813f478ce925585e87cbbce60c6b"
    sha256 cellar: :any, arm64_sequoia: "717adf5106b71568280f8871af7e7653dd8c7b6ab264f282330e3bdfe22defb8"
    sha256 cellar: :any, arm64_sonoma:  "0bcd146a32998e37d38cfa724d0a53fc815acfed193c726d1cd724459fee2d03"
    sha256               x86_64_linux:  "93d4b1f0adb9766a0d65a718924eef2c5ace86ccf47a035b54f7b8e0935fe2f6"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "eigen@3" => :build # TODO: drop the "@3"
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "factory"
  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "frobby"
  depends_on "gdbm"
  depends_on "givaro"
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libffi"
  depends_on "libomp" if OS.mac?
  depends_on "libxml2" unless OS.mac?
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "nauty"
  depends_on "normaliz"
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?
  depends_on "python@3.14" # brew linkage --test expects specific version
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
    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/ForeignFunctions.m2", "get \"!brew --prefix\"", "getenv \"HOMEBREW_PREFIX\""

    # c.f. https://github.com/Macaulay2/M2/issues/2682
    inreplace "M2/Macaulay2/d/CMakeLists.txt", "M2-supervisor", "M2-supervisor quadmath" unless OS.mac?

    # Place the submodules, since the tarfile doesn't include them
    git_clone_at_commit(
      "https://github.com/Macaulay2/M2-emacs.git",
      "M2/Macaulay2/editors/emacs",
      "a95ab17170bf6234b77fa8ccdb2431b7fb9e9dd9",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/memtailor.git",
      "M2/submodules/memtailor",
      "c7ef44a5792631f5c7da200a7a2b06e053026efc",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathic.git",
      "M2/submodules/mathic",
      "08b3c715c12d6e3a4d6b596e3fa1d49a9ee77c40",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathicgb.git",
      "M2/submodules/mathicgb",
      "fb6af156edc37c0563f0d98993496e43620a3f17",
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
index 74cbf52367..8c8bb4f4f5 100644
--- a/M2/Macaulay2/m2/packages.m2
+++ b/M2/Macaulay2/m2/packages.m2
@@ -204,7 +204,6 @@ needsPackage String  := opts -> pkgname -> (
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
index 118fa2acac..511a9ecab7 100644
--- a/M2/Macaulay2/packages/Topcom.m2
+++ b/M2/Macaulay2/packages/Topcom.m2
@@ -319,7 +319,7 @@ topcomIsTriangulation(Matrix, List) := Boolean => opts -> (Vin, T) -> (
       << "Index sets do not correspond to full-dimensional simplices" << endl;
       return false;
    );
-   (outfile, errfile) := callTopcom("points2nflips --checktriang -v", {topcomPoints(V, Homogenize=>false), [], T });
+   (outfile, errfile) := callTopcom("points2nflips --checktriang --memopt -v", {topcomPoints(V, Homogenize=>false), [], T });
    not match("not valid", get errfile)
 )
 
-- 
2.43.0
