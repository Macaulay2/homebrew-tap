class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.6/mathic-1.6.tar.gz"
  sha256 "337f303eeab2f834ee21973fc69ab862f9d6b8976887e4b5e2371759298abe2c"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a8ea1ffe243b5159338d828784c0c21b4a07c52ad97cbf4300bc415284e84c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36a6eae8a684f13d58765967d60263188b53d4802b6109e40da7a0e118d6dd69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "96bf5cc0e54482f36d8db87b6e24af7413dee7d3d5ff70d9d46167ef52d8ee7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ee6328039963c2d91cee11b8bb9eb63c7c68c6b9db5fc206f1c3eb305d0390c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "39f2c5760941737a811b08fc05955548795493d6f07935d9f61e106c0aefdea0"
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
