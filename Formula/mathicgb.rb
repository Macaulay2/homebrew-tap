class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.2/mathicgb-1.2.tar.gz"
  sha256 "5052ea8b175658a018d51cecef6c8d31f103ca3a7254b3690b4dbf80cbf0322e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59389c67bfadb387d19a4967a7c18036409c97c7170a603746c15fd11f6f9a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bfdab3674cdeb019aba884ac3d980657958455089b04c4db02a250dc92a7e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7792188e5147e82e372fab44b6befa62c0d82b3c1aaf501a1a80de5eb603293e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65fe752381acdd8413e87a5038e46db9d5fd3075bd15e31f5c110fbd36258b6f"
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"
  depends_on "tbb"

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix};#{Formula["mathic"].prefix}"
    args << "-Denable_mgb=off" if build.without?("mgb")
    args << "-Dwith_tbb=on" << "-DTBB_ROOT_DIR=#{Formula["tbb"].prefix}" if build.with?("tbb")
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
