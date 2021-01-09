class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/mahrud/frobby.git", using: :git, branch: "feature/cmake"
  version "0.9.4"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/frobby-0.9.1_3"
    cellar :any_skip_relocation
    sha256 "b25a5b4bdc0cf2e29a694213bc7c4c683c047d641c5bea01f8a932e30995d152" => :catalina
    sha256 "1a2615f7852697c0d78734de413b9d13936a01d3957be22aa5539ddb29edd151" => :x86_64_linux
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
