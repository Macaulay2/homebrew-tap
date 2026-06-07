class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.4/mathic-1.4.tar.gz"
  sha256 "722ab0cc970a251040597975d7700576060f031b2dc4f4465ff59d5bc604ede0"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d6a6464d30bea7023ef211693b17d7334592d83876119c48e9500210fa19863"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f4884f1da75fbbfb3a66a771728a890af2f4ae0870dff38c3aa3b085897f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfa81d11e0358978029b8574a8972d80051321480e681205435c2a496ca7bd54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc687cdc994c05c05e46052b1b5d7317cfae3204296569a77abd38a59db540af"
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
