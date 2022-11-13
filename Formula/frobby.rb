class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"
  revision 4

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.5_4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ecec47d673eef61a73082772f3a383ee99c2b186e1c99a16c0b245fdfc87f0d"
    sha256 cellar: :any_skip_relocation, monterey:       "de11dfa58b111f3a1cc2e6cf4e9ab387d56356c68920ca727800cc1460295782"
    sha256 cellar: :any_skip_relocation, big_sur:        "a771081b280379145c3656002582d82a2278f73f5492d672ce0e76d4255a9640"
    sha256 cellar: :any_skip_relocation, catalina:       "4400a38be4024e11d76dbb40488f66d062befba6b0f24653436b2b33549a0028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b283abcb0fe6cef36f2f8cbb812da4c111e4f7c185d64092cbbd32306583a8f"
  end

  unless OS.mac?
    depends_on "llvm" => :build
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "gmp"

  def install
    ENV.cxx11
    unless OS.mac?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    end
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
