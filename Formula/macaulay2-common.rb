class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "ae882ab04da19f62c62462ef9604251a0b30a9f5"
  version "1.26.06"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.26.06" do
    url "https://ghcr.io/v2/macaulay2/tap/macaulay2/blobs/sha256:10c7e99660344f82945ad450bdef35b9665bffef15c986f24b805a7ea8d78dee"
    sha256 "10c7e99660344f82945ad450bdef35b9665bffef15c986f24b805a7ea8d78dee"
  end

  def install
    resource("v1.26.06").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.26.06/share", prefix
    mv buildpath/"1.26.06/lib",   prefix
    rm_r share/"emacs"
  end

  def post_install
    if formula_any_version_installed?("macaulay2")
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
