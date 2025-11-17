class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.1/linbox-1.7.1.tar.gz"
  sha256 "a2b5f910a54a46fa75b03f38ad603cae1afa973c95455813d85cf72c27553bd8"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "c8128bc3326f4ecd6c3dccf368710652eb5b9cca296774a616a9bae40b10ecb9"
    sha256 cellar: :any,                 arm64_sonoma:  "e6cacf1db93748d753288fa0ecf943388e6b14f094430a915942ee45e2c40ff6"
    sha256 cellar: :any,                 ventura:       "4b648e2c82b935a2bc3ea5aedb66cfe1f9bb60b150477f94a665966491409d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c65195e1b33e7a202622c462869947ef39c58b9d21ecae005c5752987924475"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "ntl"
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
