class Frobby < Formula
  desc "Computations With Monomial Ideals"
  homepage "https://www.broune.com/frobby/"
  url "https://github.com/Macaulay2/frobby.git", using: :git, branch: "master"
  version "0.9.5"
  license "GPL-2.0-only"
  revision 3

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/frobby-0.9.5_3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e7bb29fe1c62d272d7971efce0328f0e0b07e7b383d8937855e9849f6bce7c3"
    sha256 cellar: :any_skip_relocation, monterey:       "702731828706965b0979b4457bd0b2e06354006b9d72279684cb77f837880da7"
    sha256 cellar: :any_skip_relocation, catalina:       "c83aef13da2a57ca68b8dec3aed4cc83e0fe451cdbf5207a006a7b0d95202aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22765bce23fb27bc4ec9a20b7f6e7f7ed1bbc4870333fc917331bcc66857b32a"
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
