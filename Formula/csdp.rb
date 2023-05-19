class Csdp < Formula
  desc "Semidefinite programming problems"
  homepage "https://github.com/coin-or/Csdp"
  url "https://github.com/coin-or/Csdp/archive/releases/6.2.0.tar.gz"
  sha256 "3d341974af1f8ed70e1a37cc896e7ae4a513375875e5b46db8e8f38b7680b32f"
  license "EPL-2.0"
  revision 10

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/csdp-6.2.0_10"
    sha256 cellar: :any,                 arm64_monterey: "6fac45891ea250fce3c1993d4f6c5d02a3b8405749679978b2025090e614bc2d"
    sha256 cellar: :any,                 big_sur:        "0d5f7ed8c4a69c953213282c03ef1b3c72d5c1baa161b1333777d33627983c0f"
    sha256 cellar: :any,                 catalina:       "88bd43d2ba3a3de9553340d82ffbc09841594d745e5a4dfbcf18e7cfd266ad8e"
    sha256 cellar: :any,                 monterey:       "47b47c395599aa3e554d1662fa1f5f1c551d2687a26a058b9544854877313f31"
    sha256 cellar: :any,                 ventura:        "dd69682009d1268e2939e4e137291402c6984bc5d095a52e0ef8e1d564527018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9934c8cc38a93e3f2561f43bacae30811b9833e527289101eec76c86e53c15"
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
