class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"

  depends_on "cmake" => :build

  depends_on "memtailor"

  def install
    system "cmake", ".",
           "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
