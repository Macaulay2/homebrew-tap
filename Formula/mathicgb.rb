class Mathicgb < Formula
  desc "Compute (signature) Groebner bases using the fast datastructures from mathic"
  homepage "https://github.com/Macaulay2/mathicgb"
  url "https://github.com/mahrud/mathicgb.git", using: :git, branch: "master"
  version "1.0"
  license "GPL-2.0-or-later"
  revision 7

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/mathicgb-1.0_7"
    sha256 cellar: :any,                 catalina:     "d4c2aff900c7b029f610ef7186a18805d9cfd8ddddfbced6f5c858c069933afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4a21ed29476caf318cf2d53f09134e85be8cbdfce4f7dd00bf8d15397a2efbb2"
  end

  option "without-mgb", "don't build mgb"

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "mathic"
  depends_on "memtailor"

  depends_on "tbb@2020_u3" => :recommended

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DBUILD_TESTING=off"
    args << "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix};#{Formula["mathic"].prefix}"
    args << "-Denable_mgb=off" if build.without?("mgb")
    args << "-Dwith_tbb=on" << "-DTBB_ROOT_DIR=#{Formula["tbb@2020_u3"].prefix}" if build.with?("tbb@2020_u3")
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "true"
  end
end
