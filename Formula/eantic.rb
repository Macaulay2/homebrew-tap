class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.1.0/e-antic-2.1.0.tar.gz"
  sha256 "e3e78701d054b441f95d83b6fb55cd84bfd931f5d4a61a2822dc977a20c46f80"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]

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
index 35577c2..ce719ac 100644
--- a/pyeantic/src/Makefile.am
+++ b/pyeantic/src/Makefile.am
@@ -3,7 +3,7 @@ all-local:
 	cd $(abs_srcdir) && $(PYTHON) $(abs_srcdir)/setup.py build --verbose --build-base $(abs_builddir)/build
 
 install-exec-local:
-	$(PYTHON) $(abs_srcdir)/setup.py install --prefix $(DESTDIR)$(prefix) --single-version-externally-managed --record $(DESTDIR)$(pythondir)/pyeantic/install_files.txt --verbose
+	echo "warning: skipping pyeantic due to https://github.com/flatsurf/e-antic/issues/283"  #$(PYTHON) $(abs_srcdir)/setup.py install --prefix $(DESTDIR)$(prefix) --single-version-externally-managed --record $(DESTDIR)$(pythondir)/pyeantic/install_files.txt --verbose
 
 uninstall-local:
 	cat $(DESTDIR)$(pythondir)/pyeantic/install_files.txt | xargs rm -rf
-- 
2.34.1
