class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.0.2/e-antic-2.0.2.tar.gz"
  sha256 "8328e6490129dfec7f4aa478ebd54dc07686bd5e5e7f5f30dcf20c0f11b67f60"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbbd074435c91b1b4e3159c6b9214488832302cbf58fe0d48325324ef1191e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e6ca2e11c43f3ec25d0d9b406f76ab796ddc619e82c4227d792eba6853d42a"
    sha256 cellar: :any_skip_relocation, ventura:       "60079eead5875bae38c96ccb5fbac8261073b36763bb46b4623bf5192e19bf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c54e1a3a8090ea2fbee2f341074a82ccbfd749ae19455cf87380e44bd167ca"
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
