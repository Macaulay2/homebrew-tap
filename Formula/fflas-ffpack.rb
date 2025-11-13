class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/linbox-team/fflas-ffpack/releases/download/v2.5.0/fflas-ffpack-2.5.0.tar.gz"
  sha256 "dafb4c0835824d28e4f823748579be6e4c8889c9570c6ce9cce1e186c3ebbb23"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/fflas-ffpack.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c8eaf4b6df9eb77de2bdf440074c5f66637daa7ddfed268769544db60f1e867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1280e2d7cb7fb0a144dfcc2af29023d861bde51bb198b246bfa03793ad7aabc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276f1bc934328c848c25812fa5dc0308deb4eff70e9bd89dce2f6630ddabf67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f08ed61fcd8b4511512887fea26d4fe17906e083159e058109574a0b66450d7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "openblas" unless OS.mac?

  def install
    ENV.cxx11
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OMPFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    else
      ENV["OMPFLAGS"] = "-fopenmp"
    end
    ENV["CBLAS_LIBS"] = ENV["LIBS"] = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "autoreconf", "-vif"
    system "./configure",
           "--enable-openmp",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
