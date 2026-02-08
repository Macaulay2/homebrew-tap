class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.1/linbox-1.7.1.tar.gz"
  sha256 "a2b5f910a54a46fa75b03f38ad603cae1afa973c95455813d85cf72c27553bd8"
  license "LGPL-2.1-or-later"
  revision 1

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "acd973169cd0f2454721ff48502c5faecd44c2f84d9ea6e93bee5f19d978fbf6"
    sha256 cellar: :any,                 arm64_sequoia: "d05a3a883c75b59a5ff98aac180a1c5a21c0c6d149d8a8f163b535dcc17684a8"
    sha256 cellar: :any,                 arm64_sonoma:  "abcabd37ea766bbfd996d694ec5c925092cbdc4ea35d29e883ebc0de2a43115a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6806d6ee9afc61c3a4ef674a612de2ff0f38fc224a722464225d3756b6f7439c"
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

  # avoid type conversion errors
  patch do
    url "https://sources.debian.org/data/main/l/linbox/1.7.1-2/debian/patches/ntl-zz-px.patch"
    sha256 "c1f727d373cef5340ad51b188642a89ffdecbd6bc03ed4318a7e1b829c0cce9f"
  end

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
