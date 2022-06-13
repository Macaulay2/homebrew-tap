class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "5029b532a2738d476fd685ac8d57324133c6d83e"
  version "1.20"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-common-1.20"
    sha256 cellar: :any_skip_relocation, big_sur:      "1b51560ff19f4e6cb7f17d8cd08b2475de2fb3685d65aabdab1b25f120fba3f8"
    sha256 cellar: :any_skip_relocation, catalina:     "100d187a61169f063f7e1dc4e3f90ec57c9baad994702009d1a69b24aeb1c1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0db170b02a83a635525e3dcc3b3a79257be055b625472ce0ed2a31399eb99327"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.20" do
    url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-1.20_2/macaulay2-1.20_2.big_sur.bottle.tar.gz"
    sha256 "8e840e42d134e094d0b854d7c934f44ec2ceb465859158830d03ca1cc5e850a0"
  end

  def install
    resource("v1.20").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.20_2/share", prefix
    mv buildpath/"1.20_2/lib",   prefix
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
