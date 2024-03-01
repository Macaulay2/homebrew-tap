class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic.git", using: :git, branch: "master"
  version "1.0"
  license "LGPL-2.0-or-later"
  revision 5

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mathic-1.0_5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "b5c1535522f276c53035d7f5418674df0de88edfc3589b4a9209fb381e38c111"
    sha256 cellar: :any_skip_relocation, ventura:      "8dca8a49ac1ef9e70350a3e8c79cf53ae3b4510914edc8061ab61952531fc296"
    sha256 cellar: :any_skip_relocation, monterey:     "3de8fc2811cfdea267d642378dcbd42afc90be289021a64ae22ae9e4f31f6a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b798aaa001e7c54e73dd94e2363f13e1a28632f1d5e64b1f8ace45b01f472b55"
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
