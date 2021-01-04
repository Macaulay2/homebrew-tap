class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"

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
