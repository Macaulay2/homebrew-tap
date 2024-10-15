class Csdp < Formula
  desc "Semidefinite programming problems"
  homepage "https://github.com/coin-or/Csdp"
  url "https://github.com/coin-or/Csdp/archive/refs/tags/releases/6.2.0.tar.gz"
  sha256 "3d341974af1f8ed70e1a37cc896e7ae4a513375875e5b46db8e8f38b7680b32f"
  license "EPL-2.0"
  revision 10

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e6b76a606628f3b8f84f8577d69bb46b57ad90168d3c13873b920228d1666e3a"
    sha256 cellar: :any,                 arm64_sonoma:  "aa620aca33806e6a3ecdbbd8cc61dcb20b2a2500d236373ac15211382ef824cf"
    sha256 cellar: :any,                 ventura:       "2fe5297019b55955c8eec379889cf74640f9f8980dfd4b6467d44e4178bb6f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "294df2cff652bfd6f1af91a35a3e02397c9392508a4e64223256509baad9e2f6"
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
