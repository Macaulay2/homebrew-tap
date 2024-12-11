class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.0.2/e-antic-2.0.2.tar.gz"
  sha256 "8328e6490129dfec7f4aa478ebd54dc07686bd5e5e7f5f30dcf20c0f11b67f60"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e8ef3fe37854d58fb75c7ed58ee7549b4972253fb829306f160c7ef28c8868"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de2ad94f769b55b1ba12dbb3ac3ffd4eb666d1a2b8e51d29d518ec7cc1eca146"
    sha256 cellar: :any_skip_relocation, ventura:       "3005bb2e581a81a157e9f18ee88e3e5f61002e5a3f545ae6ce01b037f45ab85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08733bf692c6201c1dee197cf070bf4eb17a05aaff361681caaee70cdf6adf7f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "boost"
  depends_on "flint"

  def install
    ENV.cxx11

    args = [
      "--prefix=#{prefix}",
      "--disable-shared",
      "--disable-silent-rules",
      "--disable-dependency-tracking",
      "--without-benchmark",
      "--without-byexample",
      "--without-pytest",
      "--without-doc",
    ]

    system "autoreconf", "-vif"
    system "./configure", *args
    system "make", "install"
    system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end
