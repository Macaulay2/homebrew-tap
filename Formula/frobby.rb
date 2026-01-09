class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.7/frobby_v0.9.7.tar.gz"
  sha256 "efd0a825b67731aa5fb4ea8d2e1004830cc11685be3e09f5401612c411214a96"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "8751c00a38717555333d78716a878c3306e57dba007e564caad466b147fd8140"
    sha256 cellar: :any,                 arm64_sequoia: "525bdf9f57d5d8cc57a6b2270ca1a41c2fe788e96fcf746697ea4e05ee5f557b"
    sha256 cellar: :any,                 arm64_sonoma:  "711fdc348f52bc4283ecfe877b7ea13037a21243702523828c42960b921a9714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7060d6ae41a3e95d9bfcd0cc4a3c8de6aaa9837c9e47680b9b5d4b4c47db65d7"
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
