class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"
  revision 4

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mathic-1.0_4"
    sha256 cellar: :any_skip_relocation, catalina:     "6fcbcbd3b32224ba3b2cfa82590207484ad288c6fe785f9a3b855cf8ab1f9d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2de9c4f19a7fc5e8697d086987c6a46bad8c6bb3b66708d827ce00a829c71455"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "memtailor"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
