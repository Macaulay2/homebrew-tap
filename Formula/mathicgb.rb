class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.3/mathicgb-1.3.tar.gz"
  sha256 "d700c6d6d65f6d8c5c40d79e1012f1e60e6e2114100ce73a719be93770bd23d9"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01bd27305297de513710c35d3a4fd98f4c08af24c00249c8f834de04d057cd29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ebc23288552ab59a9928358b185299333f2f79a89fcc58de9ca6305aa9bdc48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c07dc509bb68b1819998dade31c1a1fadef1859617ff8aa856ce39cf95006d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21dcd8abc1f80eb4a90627e5841db2ee2b37aece24e02f396bfa766bb8413e9d"
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
