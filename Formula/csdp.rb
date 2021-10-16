class Csdp < Formula
  desc "Semidefinite programming problems"
  homepage "https://github.com/coin-or/Csdp"
  url "https://github.com/coin-or/Csdp/archive/releases/6.2.0.tar.gz"
  sha256 "3d341974af1f8ed70e1a37cc896e7ae4a513375875e5b46db8e8f38b7680b32f"
  license "EPL-2.0"
  revision 8

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/csdp-6.2.0_7"
    sha256 cellar: :any_skip_relocation, catalina:     "de75ad40ebb2b2c6a6bb96f9990a42d381a85c686465032c5f6a402ceb636d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "10679331bc00139b5ae0952344cc7a4502b93739a805d6c3123454a2b6c25c3f"
  end

  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  # patch for compatibility with macOS
  patch do
    url "https://raw.githubusercontent.com/Macaulay2/M2/1f99f71a1308318679412de7f20e940b05f80be6/M2/libraries/csdp/patch-6.2.0"
    sha256 "e836252c67056e5bc755d24d7a43ccad653139fe8b0b1d2dba064f68da41791c"
  end

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OpenMP_C_FLAGS"] = "-Xpreprocessor\ -fopenmp\ -I#{libomp.opt_include}"
      ENV["OpenMP_C_LDLIBS"] = "#{libomp.opt_lib}/libomp.a"
      ENV["LA_LIBRARIES"] = "-framework Accelerate"
      # see https://github.com/Macaulay2/homebrew-tap/issues/103#issuecomment-944225248
      inreplace "Makefile", /-ansi/, ""
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
