class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2/archive/release-1.19.tar.gz"
  sha256 "08c110d0081c8408eec60e11cee363d9b62e82c212a9f099247be1940057b071"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.18_2"
    sha256 cellar: :any, catalina:     "785626195f2f12a592bb10c4a1ae7aeaee3c49cb5489dd1837b5b004c1a79eb0"
    sha256               x86_64_linux: "b7b8cdc891e55468ee373cf3599049c0189bdba6422c7cebfe9ab5245dbf54ec"
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
  depends_on "mpfi"
  depends_on "mpfr"
  depends_on "mpsolve"
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?
  depends_on "readline"
  depends_on "tbb@2020_u3"

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
    unless head?
      system "git", "clone", "https://github.com/Macaulay2/M2-emacs.git", "M2/Macaulay2/editors/emacs",
             "--branch", "main"
      system "git", "clone", "https://github.com/Macaulay2/memtailor.git", "M2/submodules/memtailor"
      system "git", "clone", "https://github.com/Macaulay2/mathic.git", "M2/submodules/mathic"
      system "git", "clone", "https://github.com/Macaulay2/mathicgb.git", "M2/submodules/mathicgb"
    end

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
