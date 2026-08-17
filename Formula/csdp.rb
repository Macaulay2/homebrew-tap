class Csdp < Formula
  desc "Semidefinite programming problems"
  homepage "https://github.com/coin-or/Csdp"
  url "https://github.com/coin-or/Csdp/archive/refs/tags/releases/6.2.0.tar.gz"
  sha256 "3d341974af1f8ed70e1a37cc896e7ae4a513375875e5b46db8e8f38b7680b32f"
  license "CPL-1.0"
  revision 11

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "3d858355e2be61bef2798eead217ee37a77ac4788b2aecfa014d0e6a5b160681"
    sha256 cellar: :any,                 arm64_sequoia: "6ff4935bcab1468599ba2c78d26a2106a9f7565254632a0e13c344a8766ae3bb"
    sha256 cellar: :any,                 arm64_sonoma:  "fe20ca55ec5c5318451454fcf09e066182abf5285619e5a6435317f660b37d4d"
    sha256 cellar: :any,                 sequoia:       "7fb062b8abd91ca2baa793a53be804f3ca6e6a5392fa349c61777327682a9052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc6fa3b8891f6764fd02129edc547b124d034ed9e89bad00c042b6fd3ac69eea"
  end

  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  # include <stdio.h> to avoid declaring printf implicitly
  patch do
    url "https://salsa.debian.org/math-team/csdp/-/raw/d95bdd34978926971e8b3fcf6622f3086d3b2401/debian/patches/include-stdio.patch"
    sha256 "fcd9b1ba04d20a6f150fc56a918f9bcd6ee1681203a9a0bc2aace385694fd54f"
  end

  # more configurable makefile
  patch do
    url "https://salsa.debian.org/math-team/csdp/-/raw/d95bdd34978926971e8b3fcf6622f3086d3b2401/debian/patches/makefile.patch"
    sha256 "8d51be78e50708085a8749fcac1b23a5dd24d404cee32a388d7c0c40ba474d5c"
  end

  def install
    make_args = if OS.mac?
      ["BLAS_LIBS=-framework Accelerate",
       "OPENMP_CFLAGS=-Xpreprocessor -fopenmp -I#{formula_opt_include("libomp")}",
       "OPENMP_LIBS=-L#{formula_opt_lib("libomp")} -lomp"]
    else
      ["BLAS_LIBS=-L#{formula_opt_lib("openblas")} -lopenblas"]
    end

    system "make", *make_args
    system "make", "install", "prefix=#{prefix}", *make_args
  end

  test do
    # The 5-cycle is self-complementary, with Lovasz theta number sqrt(5).
    # Upstream asks for six digits or more (test/Makefile).
    (testpath/"c5.graph").write <<~EOS
      5
      5
      1 2
      2 3
      3 4
      4 5
      1 5
    EOS

    system bin/"complement", "c5.graph", "c5-complement.graph"
    system bin/"graphtoprob", "c5-complement.graph", "c5.dat-s"
    csdp_output = shell_output("#{bin}/csdp c5.dat-s")
    assert_match "Success: SDP solved", csdp_output
    assert_in_delta Math.sqrt(5), csdp_output[/Primal objective value: (\S+)/, 1].to_f, 1e-6

    theta_output = shell_output("#{bin}/theta c5.graph")
    assert_in_delta Math.sqrt(5), theta_output[/Lovasz Theta Number is (\S+)/, 1].to_f, 1e-6
  end
end
