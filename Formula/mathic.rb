class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.5/mathic-1.5.tar.gz"
  sha256 "42acb4886bdae84e3117aca52ec63b64693cbd0c7e3ca288fc789661d556ea20"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e573086c1919807cfc49fcf1da1003c42a20de21d17f7f0d200270955b09c31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661a25450216eeb86ab4e60410d81b3f6c187b50cd7e197f662272890bd170d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2c068da2f993a5fd001eed7939449b2d0ab2618c0cf3c4d3c09ed1928ea1a6"
    sha256 cellar: :any_skip_relocation, sequoia:       "f18ba70e4355eff9cd7f87b80732b424f17f04a0c3007c956dac2b895b3019c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec167504d4240956c2f1b54c7b447053de8817ab49f21f93539d5dba1b30e9e3"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "memtailor"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
