class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.1/linbox-1.7.1.tar.gz"
  sha256 "a2b5f910a54a46fa75b03f38ad603cae1afa973c95455813d85cf72c27553bd8"
  license "LGPL-2.1-or-later"

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "05d70835ee212646a363ca38fd6e66c476224f4a3167147bd15fa50cd97b2bfb"
    sha256 cellar: :any,                 arm64_sequoia: "487a31721d575a89baa6b0857d88c9e90811551f33e5ce9880f06694413c45bd"
    sha256 cellar: :any,                 arm64_sonoma:  "33ff2e7e65fd25de0951fb4b083fd7383b60f81e519467c02ec1f882d7e01d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c596ed0ba025d3ae705a9da9f13c140045c0d915113eb8b3e7e41ea09c671d7"
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
