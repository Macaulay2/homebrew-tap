class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "01d4439fd07e3a598be892f012babb0d60839cf03c905a869d7573a5a825a02a"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab66a4f1c0a6a992ae5d17dea55ad5bb0a8bc919bae5a0245f4bcb3ecd9f82e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24471aad54076fa11b0691c0ae5915f2b0a66d2c1342078480e489aa5de5d7ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d49c8c9d2d265e33c878afe41ce77dfdcd5e07d2574143c7dc65e97e1e819b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e27dca11720e37cac49e270005d9303e04d4f7eb171347a256ed271be08551"
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
