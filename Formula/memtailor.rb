class Memtailor < Formula
  desc "C++ library of special purpose memory allocators"
  homepage "https://github.com/Macaulay2/memtailor"
  url "https://github.com/Macaulay2/memtailor.git", using: :git, branch: "master"
  version "1.0"
  license "BSD-3-Clause"
  revision 6

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/memtailor-1.0_6"
    cellar :any_skip_relocation
    sha256 "9eb1cdbd22f6226908ab1c6b24e6dc6a2a137a6af7711cb4eaca7828baf4f921" => :catalina
    sha256 "910d8a411f191addc90fb2f2437fac949cbee4469521881748e355212249794a" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "llvm" => :build
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    cxx = OS.mac? ? ENV.cxx : "#{Formula["llvm"].opt_bin}/clang++"
    system "cmake", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_CXX_COMPILER=#{cxx}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
