class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"
  revision 5

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e8560b7122d1d5b6b96207bc542f3ea391676c038a7a1b1486b5223c07a807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a189732e48128ae8d92c4a996aa2a57003d38397a1d8bcb04319e449d997d07"
    sha256 cellar: :any_skip_relocation, ventura:       "143537606638b12a10e7a4d1209b5d02003274e94030ea2c30076991b50e59ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca11b89ae883dbe4dda6b307449d0605d5abe5976814d77cda8db7a97ca37da"
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
