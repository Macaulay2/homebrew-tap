class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "d84f0bdefe0e09b23721fbd3b7e2f626e3206602bd245456f4ebfab445f05eb3"
  license "GPL-2.0-or-later"

  head "https://gitlab.lip6.fr/safey/msolve.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "005867776909e7e5d90b70b7286ec82990e391cd96c08e730db38ea9e31292eb"
    sha256 cellar: :any,                 arm64_sonoma:  "c50a5f52c534ee19ae9fa633bbdedb4cdc6b80e7610d40c5d2eaefa0bbc650a6"
    sha256 cellar: :any,                 ventura:       "5c6d36863dd349ef08f70f992211aa35c0e64259ebbfa5ecc09eb4c3be531a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a11a783138dbd62902b6d50d51a5753aea46e5db2c4085972ac724616682b8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "mpfr"

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OPENMP_CFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    end

    system "autoreconf", "-vif"
    system "./configure", *std_configure_args,
           "--disable-dependency-tracking",
           "--enable-openmp=yes",
           "CC=#{ENV.cc} #{ENV["OPENMP_CFLAGS"]}"
    system "make", "install"
  end

  test do
    (testpath/"eco10-31.ms").write <<-EOS
      x0,x1,x2,x3,x4,x5,x6,x7,x8,x9
      1073741827
      x0*x1*x9+x1*x2*x9+x2*x3*x9+x3*x4*x9+x4*x5*x9+x5*x6*x9+x6*x7*x9+x7*x8*x9+x0*x9-1,
      x0*x2*x9+x1*x3*x9+x2*x4*x9+x3*x5*x9+x4*x6*x9+x5*x7*x9+x6*x8*x9+x1*x9-2,
      x0*x3*x9+x1*x4*x9+x2*x5*x9+x3*x6*x9+x4*x7*x9+x5*x8*x9+x2*x9-3,
      x0*x4*x9+x1*x5*x9+x2*x6*x9+x3*x7*x9+x4*x8*x9+x3*x9-4,
      x0*x5*x9+x1*x6*x9+x2*x7*x9+x3*x8*x9+x4*x9-5,
      x0*x6*x9+x1*x7*x9+x2*x8*x9+x5*x9-6,
      x0*x7*x9+x1*x8*x9+x6*x9-7,
      x0*x8*x9+x7*x9-8,
      x8*x9-9,
      x0+x1+x2+x3+x4+x5+x6+x7+x8+1
    EOS
    system bin/"msolve", "-f", "eco10-31.ms"
  end
end
