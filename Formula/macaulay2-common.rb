class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "5029b532a2738d476fd685ac8d57324133c6d83e"
  version "1.20"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-common-1.19.1"
    sha256 cellar: :any_skip_relocation, all: "00f992f5c9e975c88040516e514b17a934f4476d895304d05118dc0f8efe22d0"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.20" do
    url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.20_3/macaulay2-1.20_3.big_sur.bottle.tar.gz"
    sha256 "5b8298ec50c3bd3d3007f53bdbbde3ddbd48cdb1962d90cace69627e1bb4f983"
  end

  def install
    resource("v1.20").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.20_3/share", prefix
    mv buildpath/"1.20_3/lib",   prefix
    rm_rf share/"emacs"
  end

  def post_install
    if Formula["macaulay2"].any_version_installed?
      cp_r share, Formula["macaulay2"].prefix, remove_destination: true
      cp_r lib,   Formula["macaulay2"].prefix, remove_destination: true
    else
      missing_warn = <<~EOS
        No version of Macaulay2 was found; run:
          brew install macaulay2 --HEAD
        to build Macaulay2 from source, then add the common documentation files with:
          brew postinstall macaulay2-common
      EOS
      opoo missing_warn
    end
  end

  test do
    system "true"
  end
end
