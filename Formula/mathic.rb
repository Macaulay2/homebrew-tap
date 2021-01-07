class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathic-1.0_1"
    cellar :any_skip_relocation
    sha256 "cbbef5fb4be900a16916e7cd305ebdcca141d4201118031b1481c0060b405419" => :catalina
    sha256 "150d6cd52bdd8bd3e332e765e0a609414695d160de6b6ed18538958e8747642d" => :x86_64_linux
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
