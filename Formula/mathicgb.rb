class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/Macaulay2/mathicgb/releases/download/v1.4/mathicgb-1.4.tar.gz"
  sha256 "3c13033762fc8e26c6c47e8e2e8557fcbae030f7514372dc47b0c71272b7304e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4de1ebd827b7485623fb393309ecd62df9e782e9b20b5f7504dfde5466e3afa5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36062362b6506b1450bcc91ed210f8a79ce39fbb9424a9a5a34fc915da42480f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a91f887730a6e96f91f909ee95fa37069a7423b2a6258b9cfdecd07a4aa96a"
    sha256 cellar: :any_skip_relocation, sequoia:       "3137dc3bbdf4c01557c9f7ec1069221b2896075f940a81eb3776fba2bf4f04e6"
    sha256 cellar: :any,                 x86_64_linux:  "22455eeebd057476c23c3a212836b50dae1961205060bfd4d18c9b2bcc00d0c9"
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
    system "cmake", "-S", ".", "-B", ".", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
