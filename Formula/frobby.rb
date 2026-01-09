class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.7/frobby_v0.9.7.tar.gz"
  sha256 "efd0a825b67731aa5fb4ea8d2e1004830cc11685be3e09f5401612c411214a96"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8f66b1e645e031bf4b514b0440b46d4ad1956e6892209d35491e4f0168e41f8f"
    sha256 cellar: :any,                 arm64_sequoia: "672dcc29801da44d49cd1595e0edf2d045b11092e8200f09127e414e216719db"
    sha256 cellar: :any,                 arm64_sonoma:  "36cca4b4789e84939f913404dc85dc86dea9a20900cccb633f98457695bdfc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90a69efa9917d0b716a4ed08b533a15dfaba1dfccf53632cd6b770b2bcfa5aac"
  end

  unless OS.mac?
    depends_on "llvm" => :build
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "gmp"

  def install
    ENV.cxx11
    unless OS.mac?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    end
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
