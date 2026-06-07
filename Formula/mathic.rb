class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.4/mathic-1.4.tar.gz"
  sha256 "722ab0cc970a251040597975d7700576060f031b2dc4f4465ff59d5bc604ede0"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db5bb5cf01eb7587b2650a072cee94e07f76c51753a5ec9aca07ff292a74a6b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f440df26afcfe71b14cc9b7076c03570becce9a09b5677d3f342802aee8b9854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c6f8309f407d600de0d5635a451a6845b6ab7518091faa84eba7ba390dda218"
    sha256 cellar: :any_skip_relocation, sequoia:       "3497677ed48b97c9b8c08a4572a0c9d00c18af97fbfbc8d615d980a30af4fcef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a55e9f2070d401253a631faa02cc100b9392afb59bf96cf0cabab7e9024bc1"
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
