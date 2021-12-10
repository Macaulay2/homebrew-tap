class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.5_2"
    sha256 cellar: :any_skip_relocation, big_sur:      "f5833a852651fe16cb62f279ad1e73f868aec6fdfc1f6ef3af39321e2948aef3"
    sha256 cellar: :any_skip_relocation, catalina:     "85b08984bd8820cd7fba45151de1ee455889e51928102df952fc193a9e643c74"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e89d9066901b8cae049ebb722b0fb03a8344dfb0f6634522e5e73423d4691f86"
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
