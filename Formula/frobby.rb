class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/mahrud/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.5"
    sha256 cellar: :any_skip_relocation, catalina:     "3c100ed1fb07fe444f151ea9614165b4ab28f5f9f64bb152519d20f3b0ffd664"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "934bac15d4d72bee4cdf1d502f99aa4d88e9bf2ec66537029f7d76bba5070688"
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
