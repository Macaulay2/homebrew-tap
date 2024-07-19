class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/libeantic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.0.2/e-antic-2.0.2.tar.gz"
  sha256 "8328e6490129dfec7f4aa478ebd54dc07686bd5e5e7f5f30dcf20c0f11b67f60"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "63acbb2126857f98d92ef333872da4e0c175ef09f5168fade9516e3d03242252"
    sha256 cellar: :any_skip_relocation, ventura:      "a4dbb0844315eaab0681c5fbd5d92edc98fb61a4f152beaf0b47a60088c56043"
    sha256 cellar: :any_skip_relocation, monterey:     "f7addedd86ff960e15297b91abb637ebe7af96f52a7fc3944379e112372d22fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7ae3963d2259c89a2ceda335ef0298ab196608b02047c1ad91685406942b9a4e"
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
