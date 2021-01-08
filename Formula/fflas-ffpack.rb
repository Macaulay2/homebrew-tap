class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/mahrud/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"
  revision 3

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/fflas-ffpack-2.4.3_2"
    cellar :any_skip_relocation
    sha256 "d0a0de02c6285ae35806ee0e7a05a68995c6d288cd799926057c64d438326a29" => :catalina
    sha256 "1d7365dce1743146ae904776114625ef27479da76f524c6969d8e6ebdec2c5fa" => :x86_64_linux
  end

  head do
    url "https://github.com/linbox-team/fflas-ffpack.git", using: :git
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
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
