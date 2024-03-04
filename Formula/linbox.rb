class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.0/linbox-1.7.0.tar.gz"
  sha256 "6d2159fd395be0298362dd37f6c696676237bc8e2757341fbc46520e3b466bcc"
  license "LGPL-2.1-or-later"
  revision 1

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/linbox-1.7.0_1"
    sha256 cellar: :any,                 arm64_sonoma: "e2efdb9d1ed680e5756ae9e3162d208124ffcbc471f3c60abbf4aa93437ed62b"
    sha256 cellar: :any,                 ventura:      "aa3efe72c0995118689e101c14f485bdf73ba5e8f4c2c52810d1e447d8ef4c62"
    sha256 cellar: :any,                 monterey:     "ecefbd6696dc3233eead7b8bf864d577e2938b8894494d2ebe1224092c6cd5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dc2c6b45edadc5ef7fae8ba064c018d3ac02a2849c0cac61504dd25b3fb2cc2e"
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
