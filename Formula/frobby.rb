class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.9/frobby_v0.9.9.tar.gz"
  sha256 "4c072c2ee208d853b7173921d45cc7d39297cf3f7fd9c8e7da8e482da3b51aa3"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1100d0b871e1f675537198d3c5f461f210b042f96421946a2ac4cf19273a5358"
    sha256 cellar: :any,                 arm64_sequoia: "090b887d946c5faad0884e4efacf24a9a268d6d8aca86ff3c46501fc4cf41369"
    sha256 cellar: :any,                 arm64_sonoma:  "c97a2bd438c135dbcf1f2facc9c7565303ea801d0efd8d29ff301464d4f0edad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b90fd6676f6e0a0a0f1df4c0556097e23fce4ef19285de12a5353d03b22f94"
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
