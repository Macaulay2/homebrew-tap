class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.2/mathic-1.2.tar.gz"
  sha256 "1a7d459290e9183e0934a6dd2278db372b831b37fdb4a6f1db7e02e0f380fe1a"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a9b4f7996b1f81d45c490d0c4231ef4941f7af8962897cb1a1d4cc799d7520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eaf81450e5577aa033ee4ed494741d6594d87de37f0fdc73e0147f88b4bf2dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ab4a720cadf7338974677490703711f1628d7ece0444a6dc563b2fd04fd447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2de0de48f5d44c948b5019d401be39bf1a115318236b18808aed0f9a302c559"
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
