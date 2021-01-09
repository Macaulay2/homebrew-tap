class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathicgb-1.0_6"
    cellar :any_skip_relocation
    sha256 "2067fb4f866250a47beafd188c68d76d29872d0125e1d2b15966531deea7c3f3" => :catalina
    sha256 "d6b0ebd30e5abc331c8192e473eed7fa0e5c44c35cabed6362bb32b2dc191a61" => :x86_64_linux
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
