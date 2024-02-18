class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/mahrud/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mathicgb-1.0_8"
    sha256 cellar: :any,                 catalina:     "b85bd14a3c2f3a23b1bee738266cede6bbb1327e325b7a6333b18ff8f80146ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "81c1808ad174bd8399b6184b6ee1a7a0fdb00758ebc3ef316f8c06221cd72d3b"
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"

  depends_on "tbb" => :recommended

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
