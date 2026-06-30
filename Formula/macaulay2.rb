class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  # when bumping to a new release, also update the submodule commits below
  url "https://github.com/Macaulay2/M2/archive/refs/tags/release-1.26.06.tar.gz"
  sha256 "54f9e892941b2b548b90656c2b6d84a6d14c6908d5569bd61e7bb36b8c71bb29"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  head "https://github.com/Macaulay2/M2/archive/refs/heads/development.tar.gz"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_tahoe:   "77f3cc83fb592f9d1bc5f6866bc94ae4c6c15ce18e5100bccdea81563fa93a00"
    sha256 cellar: :any, arm64_sequoia: "6430782c8e49361109220553cb06ce100dee75297bedb49c33c13b9364fe3458"
    sha256 cellar: :any, arm64_sonoma:  "103a85e8aae149452ac6297995e7508e1a7150a00c939c1b9e8749e710f0f3f9"
    sha256               x86_64_linux:  "afe31e4f02e4e0eeb1ad77aa15174cedc98cc881597a542f16a37730c4adc7dc"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "eigen@3" => :build # TODO: drop the "@3"
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
      "ae882ab04da19f62c62462ef9604251a0b30a9f5",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/memtailor.git",
      "M2/submodules/memtailor",
      "a74747f70d5d4f2c79c9707b64c5086eb8c051b9",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathic.git",
      "M2/submodules/mathic",
      "59238ddb4a18af81f464de3d4634c06478769c98",
    )

    git_clone_at_commit(
      "https://github.com/Macaulay2/mathicgb.git",
      "M2/submodules/mathicgb",
      "eae920070f0e9f8b34c08148f4caab7f89195601",
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
