class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mathicgb-1.0_9"
    sha256 cellar: :any,                 arm64_sonoma: "0070f02a1163c88397bc27a9e619b4a99cb6e8b07ccebb63e84b307d04fe209e"
    sha256 cellar: :any,                 ventura:      "238ec77aa4623193376ccbe2ca52eab54eec7498f0dbe9d518f4f1401889c1c1"
    sha256 cellar: :any,                 monterey:     "4e157a8ddc5f1ff704ec857e3b7a6783000cee08824f3e86115d966c70a4fa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3b6c0ea54f61c4aba3ce668a931781607edaf93913467f96814f641a901cb9b"
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"
  depends_on "tbb"

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
