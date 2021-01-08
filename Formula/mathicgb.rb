class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/mahrud/mathicgb.git", using: :git, branch: "quickfix/tbb"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 4

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
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"

  depends_on "tbb" => :optional

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix};#{Formula["mathic"].prefix}"
    args << "-Denable_mgb=off" if build.without?("mgb")
    args << "-Dwith_tbb=on" << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}" if build.with?("tbb")
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
