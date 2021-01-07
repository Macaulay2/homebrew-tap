class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/mahrud/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/fflas-ffpack-2.4.3_1"
    cellar :any_skip_relocation
    sha256 "a822619253a13db1b0af6dcdaba1c8f8ae26d135343b2be523d260cf21cced2f" => :catalina
    sha256 "b3ce316eba2ac50cf9368f5f81991ce00e38676fd553e996d38d8439ceb20a34" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/fflas-ffpack.git", using: :git
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
    ENV["CBLAS_LIBS"] = ENV["LIBS"] = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "./autogen.sh",
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
