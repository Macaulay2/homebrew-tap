class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.9/frobby_v0.9.9.tar.gz"
  sha256 "4c072c2ee208d853b7173921d45cc7d39297cf3f7fd9c8e7da8e482da3b51aa3"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "9f4d7b7c644f395f1d31281d746e1ffd72f0de92d8e43f11bb94054330236067"
    sha256 cellar: :any, arm64_sequoia: "29ec5400122b01d304c539aaa1b676ad02b7ef7498b232a396e92f3b94a9058f"
    sha256 cellar: :any, arm64_sonoma:  "fc283073fbab6202994e1dce7043dab47864f48a978103d87b98a45916f1a095"
    sha256 cellar: :any, sequoia:       "a7878758d526a9e7497d84de4f12cecf3c58321575887199deb0eff311ac2f24"
    sha256 cellar: :any, x86_64_linux:  "412135b63784e92aca45b0a687e30718792efad3175bff2a673013054819915e"
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
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
