class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/linbox-team/fflas-ffpack/releases/download/v2.5.0/fflas-ffpack-2.5.0.tar.gz"
  sha256 "dafb4c0835824d28e4f823748579be6e4c8889c9570c6ce9cce1e186c3ebbb23"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/fflas-ffpack.git", using: :git

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08c831d63ba6d67a0bc3e131ed7967a052833dfd2cb0f4d3afd432ef3deb6186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "832b9cea1e610d857d35c01a432a2c81b2523dca75ca66aa6927e748d0d4176d"
    sha256 cellar: :any_skip_relocation, ventura:       "886cee68ccab849527a2357cea74081d2b94d733541e2f47d393dca21d54b079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9ab0804e231214eeb5639a82f876dc96575f8f983cd4d2a0a17026a5d9d45d"
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
