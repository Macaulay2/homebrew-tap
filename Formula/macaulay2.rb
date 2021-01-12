class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2/archive/release-1.17.1.tar.gz"
  sha256 "8042808b07f049b941494c1538a782192f107cb85e2245e85b880f657bc73ee2"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.17.1_1"
    sha256 "54f50b6dce3a0644354c4d2be69c1400a6d21dfa1a1504380729ab6dfc55a9b8" => :catalina
    sha256 "507e59065bc000729f24a7e5bb48aa284eaf8754c4d9da4c3a4e7cba7ab75e56" => :x86_64_linux
  end

  head do
    url "https://github.com/Macaulay2/M2.git", using: :git, branch: "development"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "eigen"
  depends_on "factory@4.1.3"
  depends_on "fflas-ffpack"
  depends_on "flint@2.6.3"
  depends_on "frobby"
  depends_on "gdbm"
  depends_on "givaro"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "libatomic_ops"
  depends_on "libxml2"
  depends_on "mathic"
  depends_on "mathicgb"
  depends_on "memtailor"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "ntl"
  depends_on "openblas@0.3.13" unless OS.mac?
  depends_on "readline"

  depends_on "cohomcalg" => :recommended
  depends_on "csdp" => :recommended
  depends_on "fourtitwo" => :recommended
  depends_on "gfan" => :recommended
  depends_on "libomp" => :recommended if OS.mac?
  depends_on "lrs" => :recommended
  depends_on "nauty" => :recommended
  depends_on "normaliz" => :recommended
  depends_on "topcom" => :recommended

  depends_on "tbb" => :optional

  def install
    # Find readline via brew
    inreplace "M2/cmake/FindReadline.cmake", "NO_DEFAULT_PATH", ""
    # Install M2 major mode for Emacs where brew expects it
    inreplace "M2/cmake/startup.cmake", "site-lisp/Macaulay2", "site-lisp/macaulay2"
    inreplace "M2/Macaulay2/editors/CMakeLists.txt", "site-lisp/Macaulay2", "site-lisp/macaulay2"
    # Don't print the shims prefix path
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    unless head?
      # Place the submodule, since the tarfile doesn't include it
      system "git", "clone", "https://github.com/Macaulay2/M2-emacs.git", "M2/Macaulay2/editors/emacs"
      %w[bdwgc fflas_ffpack flint2 frobby givaro googletest libatomic_ops mathic mathicgb memtailor].each do |sub|
        # CMake doesn't like empty source directories for ExternalProject_Add
        touch "M2/submodules/#{sub}/dummy"
      end
    end

    # Prefix paths for dependencies
    lib_prefix = deps.map { |lib| Formula[lib.name].prefix }.join(";")

    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=#{lib_prefix}"
    args << "-DWITH_OMP=ON" if build.with?("libomp") || !OS.mac?
    args << "-DWITH_TBB=ON" << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}" if build.with?("tbb")

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    build_path = "M2/BUILD/build-brew"
    system "cmake", "-GNinja", "-SM2", "-B#{build_path}", *args
    system "cmake", "--build", build_path, "--target", "M2-core", "M2-emacs"
    system "cmake", "--build", build_path, "--target", "install-packages"
    system "cmake", "--install", build_path
  end

  test do
    system "#{bin}/M2", "--version"
    system "#{bin}/M2", "--check", "1", "-e", "exit 0"
  end
end
