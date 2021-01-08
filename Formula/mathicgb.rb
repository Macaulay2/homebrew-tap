class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathicgb-1.0_1"
    cellar :any
    sha256 "8642f41bf37f7804bac2b7fa2fdd04fd5714d485de82b5185b8345bf37dc38a0" => :catalina
    sha256 "3a0a528fa08158492451a057febef00a7ec9b9bf706f20eeb349b6f5e0415db9" => :x86_64_linux
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "llvm" => :build
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"

  depends_on "tbb" => :recommended

  def install
    ENV.cxx11
    cxx = OS.mac? ? ENV.cxx : "#{Formula["llvm"].opt_bin}/clang++"
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DCMAKE_CXX_COMPILER=#{cxx}"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix};#{Formula["mathic"].prefix}"
    args << "-Denable_mgb=off" if build.without?("mgb")
    if build.with?("tbb")
      args << "-Dwith_tbb=on"
      ENV["TBBROOT"] = Formula["tbb"].prefix
    end
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
