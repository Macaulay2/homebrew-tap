class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://github.com/Macaulay2/frobby"
  url "https://github.com/Macaulay2/frobby/releases/download/v0.9.8/frobby_v0.9.8.tar.gz"
  sha256 "a39fdc4d68c20bf7259ef8f11262e0f74df912be5012dfac834545aa40296301"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "2261a5d4b49ba21f5c7066688ef79fb76235e52799d392f2b361cd1ee6fa6b66"
    sha256 cellar: :any,                 arm64_sequoia: "f14a80bd0d43b33d81fed0c5d0f4ad565de7b6032eb170f49b41b7c5ef6dc362"
    sha256 cellar: :any,                 arm64_sonoma:  "327d19008836145b5f7da06fb8ce1c79475209dbdea346756cb0c94a31442d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4a5ab4094279d20246a7f2750fb29e03b98c2a90968aae55726a6106c8ad602"
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
