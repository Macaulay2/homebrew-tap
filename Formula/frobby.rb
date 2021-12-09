class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.5_1"
    sha256 cellar: :any_skip_relocation, catalina:     "93cce59a52f98ad086ee447b6c3006f272dbbeebd02892f43566c499f706b77d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8c0217b9b575bc4ca0923e37edcc3a2edaed3b2c2b8188ada6664fc3cbae2479"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "gmp"

  def install
    ENV.cxx11
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
