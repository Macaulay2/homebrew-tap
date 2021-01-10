class Macaulay2 < Formula
  @name = "M2"
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/mahrud/M2.git", using: :git, branch: "feature/cmake"
  version "1.17"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/macaulay2-1.17_1"
    sha256 "16a1a14f03eee5786877d35e0ccd2cabd3f67347011bcac43e142920107057b9" => :catalina
    sha256 "3bba661db87761a18b83b37ef1c1e1a6336a6185bd83b4ef6846e093d71abb73" => :x86_64_linux
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
    inreplace "M2/cmake/startup.cmake", "site-lisp/Macaulay2", "site-lisp/macaulay2"
    inreplace "M2/Macaulay2/editors/CMakeLists.txt", "site-lisp/Macaulay2", "site-lisp/macaulay2"
    inreplace "M2/Macaulay2/packages/Macaulay2Doc/functions/findProgram-doc.m2", "Verbose => true", "Verbose => false"

    build_path = "M2/BUILD/build-brew"
    host_prefix = ENV["HOMEBREW_M2_HOST_PREFIX"]
    lib_prefix = deps.map { |lib| Formula[lib.name].prefix }.join(";")

    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DM2_HOST_PREFIX=#{host_prefix}" unless host_prefix.nil?
    args << "-DCMAKE_PREFIX_PATH=#{lib_prefix}"

    args << "-DWITH_OMP=on" if build.with?("libomp") || !OS.mac?
    args << "-DWITH_TBB=on" << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}" if build.with?("tbb")

    if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
      ENV["SDKROOT"] = MacOS.sdk_path
    end

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
