class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.10.0/frobby-0.10.0.tar.gz"
  sha256 "5baf2133fa47c77fd87728d77b0a26e0a0e1de4a20fddab22619fe69a210ef34"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any, arm64_golden_gate: "cd86d73074fcd1aef10529b7c62ecb7d9ec3f36372236efe534bc4751d8a07f2"
    sha256 cellar: :any, arm64_tahoe:       "28eee19a918c6fcac8a999e623d12384eb3c401fe683e0d0baed8ed1f1f41e65"
    sha256 cellar: :any, arm64_sequoia:     "bb8acdacc8a4fc6f6bd0db1d739a528a43a5650c15b04c9242849ac2723eaf6c"
    sha256 cellar: :any, arm64_linux:       "e58cad235e273645d00c2e070adc890877032313da8251a4edc29459a12c951d"
    sha256 cellar: :any, x86_64_linux:      "11b5677589b1eb4c17fb3afb331cd8e3a64471a51c7f1936c0af750dd572efa9"
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
      ENV["CC"] = formula_opt_bin("llvm")/"clang"
      ENV["CXX"] = formula_opt_bin("llvm")/"clang++"
    end
    system "cmake", "-S", ".", "-B", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
