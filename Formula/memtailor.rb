class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor/releases/download/v1.3/memtailor-1.3.tar.gz"
  sha256 "10f0c016e67912be1711a54b18c54d7024c8bfcaf0f279e11187402994150a20"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "471c517e9a50c91713f19f474f74edde82aab7c8125678cbe18d4cf3ec3de904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59fdfd1517c9c041389a71f9e2b3e562a7f2e51757aa92963339393a85976d54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b4fabb7cd7584ac463422177f300c7238b2d8c0c0867937d2c7cc3821bd8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fcfd7f9900ab3c92849579799b7ca23288e6ddfbcb632cbcdeab463531f627f"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
