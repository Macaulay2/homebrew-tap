class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.0.2/e-antic-2.0.2.tar.gz"
  sha256 "8328e6490129dfec7f4aa478ebd54dc07686bd5e5e7f5f30dcf20c0f11b67f60"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bb03feb4be7598bdc83e0472342b505da97bf9ec55f8681043e045ada57b121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b4f39cdfe358e8fb3fec6f68c3feb171c3a365a58a6fdeed56d46460fc19f2"
    sha256 cellar: :any_skip_relocation, ventura:       "bbd99942bdacf0ac4e0fa07c5e9639a1a442cd42a277e4b791f8531aed047b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "483d2ed4cb5946d7220df8a29102bc022ffa1ad9ce6727adc4e9cc78ef727468"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "boost"
  depends_on "flint"

  patch do
    url "https://github.com/flatsurf/e-antic/commit/66ecdffd7e83611e1c3df5049634d88f089b0104.patch?full_index=1"
    sha256 "bdfbb3b846017bee68a53a13c974e76958f5aa5c0a50929dc3957560d616f1ec"
  end

  # skipping pyeantic due to https://github.com/flatsurf/e-antic/issues/283
  patch :DATA

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
    # system "make", "check" if build.bottle?
  end

  test do
    system "true"
  end
end

__END__

diff --git a/pyeantic/src/Makefile.am b/pyeantic/src/Makefile.am
index 2dac471..129d40c 100644
--- a/pyeantic/src/Makefile.am
+++ b/pyeantic/src/Makefile.am
@@ -3,7 +3,7 @@ all-local:
	cd $(srcdir) && $(PYTHON) $(abs_top_builddir)/src/setup.py build --verbose --build-base $(abs_top_builddir)/src/build

 install-exec-local:
-	$(PYTHON) setup.py install --prefix $(DESTDIR)$(prefix) --single-version-externally-managed --record $(DESTDIR)$(pythondir)/pyeantic/install_files.txt --verbose
+	echo "warning: skipping pyeantic due to https://github.com/flatsurf/e-antic/issues/283" #$(PYTHON) setup.py install --prefix $(DESTDIR)$(prefix) --single-version-externally-managed --record $(DESTDIR)$(pythondir)/pyeantic/install_files.txt --verbose

 uninstall-local:
	cat $(DESTDIR)$(pythondir)/pyeantic/install_files.txt | xargs rm -rf
  
-- 
2.48.1
