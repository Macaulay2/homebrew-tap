class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2/archive/release-1.18-rc1.tar.gz"
  sha256 "41e3b4f188a926c309f244fd19a288000d93866fdbca475497fc70c1c9d51e85"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.18-rc1_1"
    sha256 cellar: :any, catalina: "1b1d0682b66551e62f4d2662f8bdcb57a9f6e9fb807d0afd6a814222785b2317"
  end

  head do
    url "https://github.com/Macaulay2/M2.git", using: :git, branch: "master"
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
  depends_on "mathic"
  depends_on "mathicgb"
  depends_on "memtailor"
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "ntl"
  depends_on "openblas@0.3.13" unless OS.mac?
  depends_on "readline"

  if OS.mac?
    depends_on "tbb@2020" # has bottles for Mac OS X
  else
    depends_on "tbb@2020_u3" #  bottled for linux, too
  end

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

    # Place the emacs submodule, since the tarfile doesn't include it
    system "git", "clone", "https://github.com/Macaulay2/M2-emacs.git", "M2/Macaulay2/editors/emacs" unless head?

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
    system "cmake", "--build", build_path, "--target", "M2-core", "M2-emacs"
    system "cmake", "--build", build_path, "--target", "install-packages"
    system "cmake", "--install", build_path
  end

  test do
    system "#{bin}/M2", "--version"
    system "#{bin}/M2", "--check", "1", "-e", "exit 0"
    # system "#{bin}/M2", "--check", "2", "-e", "exit 0"
  end
end
