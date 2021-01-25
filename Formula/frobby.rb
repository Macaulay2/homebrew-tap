class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/mahrud/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.4"
    cellar :any_skip_relocation
    sha256 "7c5c4ba6a762d6aa53b746bcbcbd10809e432dc1bda80661926d32caa4788a59" => :catalina
    sha256 "e56c8c3aaa74a8258ffb1db8ca8c38ba545fe22015aa22d0b00a189df3fe14cf" => :x86_64_linux
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
