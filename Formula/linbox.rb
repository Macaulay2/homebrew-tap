class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.0/linbox-1.7.0.tar.gz"
  sha256 "6d2159fd395be0298362dd37f6c696676237bc8e2757341fbc46520e3b466bcc"
  license "LGPL-2.1-or-later"
  revision 1

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/linbox-1.7.0"
    sha256 cellar: :any,                 arm64_ventura: "b603f57c404b5b15b830ecddb81f9def82be4d57dbe88c50d5024af347842773"
    sha256 cellar: :any,                 ventura:       "e5882e9d6f41cc2233d0f6b406cc14e813ef97dacf48098161a07dcea099df74"
    sha256 cellar: :any,                 monterey:      "6cb19cdcb31f7bed85876b47f4566c0a3b4ca7399957db57926cc4c15adb173e"
    sha256 cellar: :any,                 big_sur:       "e0139e4c5caee0c3b52411a182e55569892a77f76c8bef04a1996122218aee38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feb752911c5c7156bc95400a4292b60c53ba99a2ae5de57f2e04fe25aea648c4"
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
