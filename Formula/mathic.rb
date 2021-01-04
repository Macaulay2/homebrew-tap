class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/mathic-1.0"
    cellar :any_skip_relocation
    sha256 "3057ed79af4aa8b73d1c7253084fa36dc91aaff36103d3971b81aad2cf989d93" => :catalina
    sha256 "37866efbbb8f72a6fd9f522b0bd0f2d50c735dd704274af6503a4d020e782591" => :x86_64_linux
  end

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
