class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.5/mathic-1.5.tar.gz"
  sha256 "42acb4886bdae84e3117aca52ec63b64693cbd0c7e3ca288fc789661d556ea20"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0ffff5e5bbde4661882219b7530d2d02b1dbf3892a669cb2928c7690fca8e44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e4ff53c41eba85bbbccb651daded6b88e7c53973bbaa387f80067fb679007d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59e9d817602c6ecf2a717c04e9e81d970ced2139204cfdcd715ce3aaabcdd0a9"
    sha256 cellar: :any_skip_relocation, sequoia:       "33d996f9b5e87f646fadd67de9b1b1887b335b1a121d6b703f88074df4fa93ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a39c70e92d4008cb37b3c11b04c1286ad472ca3eeb369467d1baf342606993"
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
