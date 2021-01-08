class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathic-1.0_2"
    cellar :any_skip_relocation
    sha256 "2e7102b430e1fac56282c520bce2cef6441f66572494e46a916523dab6e0a70a" => :catalina
    sha256 "309b6aa204cbc970c1acae554cf32b16e6d4eb53aefef72210e2cdce0abd8d08" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
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
