class Csdp < Formula
  desc "Semidefinite programming problems"
  homepage "https://github.com/coin-or/Csdp"
  url "https://github.com/coin-or/Csdp/archive/refs/tags/releases/6.2.0.tar.gz"
  sha256 "3d341974af1f8ed70e1a37cc896e7ae4a513375875e5b46db8e8f38b7680b32f"
  license "EPL-2.0"
  revision 10

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "3d858355e2be61bef2798eead217ee37a77ac4788b2aecfa014d0e6a5b160681"
    sha256 cellar: :any,                 arm64_sequoia: "6ff4935bcab1468599ba2c78d26a2106a9f7565254632a0e13c344a8766ae3bb"
    sha256 cellar: :any,                 arm64_sonoma:  "fe20ca55ec5c5318451454fcf09e066182abf5285619e5a6435317f660b37d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6fa3b8891f6764fd02129edc547b124d034ed9e89bad00c042b6fd3ac69eea"
  end

  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  # patch for compatibility with macOS
  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/1f99f71a1308318679412de7f20e940b05f80be6/M2/libraries/csdp/patch-6.2.0"
    sha256 "e836252c67056e5bc755d24d7a43ccad653139fe8b0b1d2dba064f68da41791c"
  end

  def install
    # see https://github.com/Macaulay2/homebrew-tap/issues/103#issuecomment-944225248
    inreplace "Makefile", /-ansi/, ""
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OpenMP_C_FLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include}"
      ENV["OpenMP_C_LDLIBS"] = "-L#{libomp.opt_lib} -lomp"
      ENV["LA_LIBRARIES"] = "-framework Accelerate"
    else
      ENV["OpenMP_C_FLAGS"] = "-fopenmp"
      ENV["LA_LIBRARIES"] = "-lopenblas"
    end

    mkdir bin
    mv "INSTALL", "INSTALL.txt" # the filename confuses `make install`
    system "make",
           "CC=#{ENV.cc} ${OpenMP_C_FLAGS} ${CFLAGS}",
           "LDLIBS=${OpenMP_C_LDLIBS}",
           "LIBS=-L../lib -lsdp ${LA_LIBRARIES} -lm"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "true"
  end
end
