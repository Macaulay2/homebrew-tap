class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.9/frobby_v0.9.9.tar.gz"
  sha256 "4c072c2ee208d853b7173921d45cc7d39297cf3f7fd9c8e7da8e482da3b51aa3"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "d3ce87efc9a9485a5f895015b711b67f091a09db29c8fccefd535f17b7784b01"
    sha256 cellar: :any, arm64_sequoia: "a4f4f8cfb3ed334a839fa85afc91235f8c41114bbeae591cc2ad57a52e2d2913"
    sha256 cellar: :any, arm64_sonoma:  "777c02a28eda28857fb7f28d6962a4642d06116cfa5931127686f57e715db4b0"
    sha256 cellar: :any, sequoia:       "72a3599dcc6a46039e75b72f01f5371471a3bab74bf2b396c837de1f022e25be"
    sha256 cellar: :any, x86_64_linux:  "ea7aadec221c0ad6bc12fa75ecd3548f04d26b43c9561b71787d50ed1416cbfa"
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
