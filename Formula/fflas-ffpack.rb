class FflasFfpack < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linbox-team.github.io/fflas-ffpack/"
  url "https://github.com/Macaulay2/fflas-ffpack.git", using: :git, branch: "master"
  version "2.4.3"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/fflas-ffpack-2.4.3"
    cellar :any_skip_relocation
    sha256 "b06359f4f2d16a8440907443477c00a24001b270ed4a1e43a3160f8f09448a4d" => :catalina
    sha256 "baecf5b205c4917abc2961ecff3dd64752695acd608e157578ea8dc055af5be6" => :x86_64_linux
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
    cblas_libs = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "./autogen.sh",
           "--enable-openmp",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "LIBS=#{cblas_libs}",
           "CBLAS_LIBS=#{cblas_libs}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
