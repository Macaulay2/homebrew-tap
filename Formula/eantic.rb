class Eantic < Formula
  desc "Computing with Real Embedded Number Fields"
  homepage "https://flatsurf.github.io/e-antic/"
  url "https://github.com/flatsurf/e-antic/releases/download/2.1.1/e-antic-2.1.1.tar.gz"
  sha256 "e3287fa603b44d9a43c4cac5d883e65e90aedc35821061c1dc5b8d9c94a01cd8"
  license any_of: ["LGPL-3.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59677591c9d4333d7f1493b0f65bf9becc6442dd23ec1309061c8eb3e8cbef8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6822512bd2f7c0090ec3e23311ce4fa828e77887b9008fa9ec48ef34fcdb8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0367a3dfbb2cb7f9371bb1b8e54bf8ff6976e8f0b738abb8473b2a923fd16ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45b18ae35674da99634d516e09dd90ba0d81ff1bd30b147a8b3223b84e47863"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "boost"
  depends_on "flint"

  # FLINT 3.6.0 declares the real root isolation functions that e-antic also
  # declares, so building against it fails with conflicting types.  Reported
  # upstream as https://github.com/flatsurf/e-antic/issues/308; patch taken
  # from Debian.
  patch do
    url "https://sources.debian.org/data/main/e/e-antic/2.1.1%2Bds-2/debian/patches/isolate-real-roots.patch"
    sha256 "0ecec1fb773e9a1a39bba1751e90cd32de7ce579126439facb3263ed1709bf4d"
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
