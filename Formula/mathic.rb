class Mathic < Formula
  desc "Symbolic algebra data structures for use in Groebner basis computation"
  homepage "https://github.com/Macaulay2/mathic"
  url "https://github.com/Macaulay2/mathic/releases/download/v1.7/mathic-1.7.tar.gz"
  sha256 "99e55dba14db57e327abcac02c2c495cf7b02411eb85dc0d58b514fbaa358d8b"
  license "LGPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9dcd838e10a69350d3e92f167dab8b7b2380c0ef11f14cdf6709a20758a3a2b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5a12bf0a437825d7697d03e6a75a4a45891550569a4c9359a295b6b62773e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75bc85b641e83811750762785e1166141f4e52bc2afb6f095ff34ce13d9d950f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37c1fa3a24a6cf522899b3cc78fa45e7fab83752d678b305d06cd57fa9b67321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5d9365a717a7a7ed5796362b9c98ca5643ce7ee495acf20ce0518ef2c0ac40ef"
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cmake" => :build

  depends_on "memtailor"

  def install
    ENV.cxx11
    system "cmake", "-S", ".", "-B", ".", "-DBUILD_TESTING=off",
           "-DCMAKE_PREFIX_PATH=#{Formula["memtailor"].prefix}",
           *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
