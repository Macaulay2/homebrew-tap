class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/mahrud/mathicgb.git", using: :git, branch: "quickfix/tbb"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathicgb-1.0_4"
    cellar :any_skip_relocation
    sha256 "f7bc6ff7705bb2933caca04007b8ed1cab5ff39d4457a09f296e5241208f1d2e" => :catalina
    sha256 "3a2c04767cd33ecce22be433d2c13c71033b2ed1c83553c65a477a2d0ddaadf5" => :x86_64_linux
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
