class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathicgb-1.0"
    cellar :any_skip_relocation
    sha256 "334f34d4695ddef2bd653e9a9636c2602f268b8f9711982b0ddccb542ce99a36" => :catalina
    sha256 "6c54d1e3d51bbbcb6c822ff20bd75025e373c34fc8bce6f7bf6619f3b597ea11" => :x86_64_linux
  end

  option "without-mgb", "don't build mgb"

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"

  depends_on "tbb" => :optional

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
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
