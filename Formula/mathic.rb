class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"
  revision 3

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathic-1.0_3"
    cellar :any_skip_relocation
    sha256 "cabe2a503dd14c4fba43a8d609724a7415650b840d3ef9e45c6993023520cd44" => :catalina
    sha256 "f6e2fa8ec5165b6ca91aee11f845a94808203a6a360a19f7d3dc96941a8a4527" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "llvm" => :build
  end

  depends_on "cmake" => :build

  depends_on "memtailor"

  def install
    ENV.cxx11
    cxx = OS.mac? ? ENV.cxx : "#{Formula["llvm"].opt_bin}/clang++"
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix}",
           "-DCMAKE_CXX_COMPILER=#{cxx}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
