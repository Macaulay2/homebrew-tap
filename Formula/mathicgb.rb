class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.4/mathicgb-1.4.tar.gz"
  sha256 "3c13033762fc8e26c6c47e8e2e8557fcbae030f7514372dc47b0c71272b7304e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5dd1672e7bda5cd771397e9e0fa75183c46ff9f6eedf58271bc868efc71f96e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be2cadf3082ee2adb474dfb6f7a39d91a725672317dd3097c9c4803a1946a3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "870debe5e24934a5c701953bbec42c7e1cbff7603483f799f351235dc4fe7092"
    sha256 cellar: :any,                 x86_64_linux:  "651cd0f51978b14924ba05bad95d70ea2f13b94bcb472b29384c908f5f164f5e"
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
