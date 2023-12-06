class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "5029b532a2738d476fd685ac8d57324133c6d83e"
  version "1.22"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-common-1.20_1"
    sha256 cellar: :any_skip_relocation, big_sur:      "5b2f3c1457cd85d8503fed486fd54dd39cabf2533d5641fc5ee4fac61f121f7d"
    sha256 cellar: :any_skip_relocation, catalina:     "1dd43e4eab5d02dff7dc10ee2cbdf5ba744af9e384a3694676b0750b545cadf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3187b44b7fe52ade5a4a073f747a97b2b48d97e7bdb6d05bebc322c95a8ce26f"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.22" do
    url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.22_2/macaulay2-1.22_2.ventura.bottle.tar.gz"
    sha256 "6f520730827d921b2f05719c43f5d260968490ab73b2240d99cc79f0a8d408b9"
  end

  def install
    resource("v1.22").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.22_2/share", prefix
    mv buildpath/"1.22_2/lib",   prefix
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
