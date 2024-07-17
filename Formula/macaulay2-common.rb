class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "e29832126afb0b153505f69eb942b0f509ac8f41"
  version "1.24.05"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "30b9480eefd0964fb6342b4d730cddd17149f4ef6ab8bc2edd14e26e384d871c"
    sha256 cellar: :any_skip_relocation, ventura:      "8dc9fda571f4d68e28abc83bd749bb6326f9336bd5817129fdf42a160e063be2"
    sha256 cellar: :any_skip_relocation, monterey:     "89c071f134e1b62f16fa2d396fb8eb9632b58f0ee5dda73ccf32306124f80b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "aaa1e33c126bf296dc4c6b17fad2ac5d18c2788a0c002033118d0d1bc3ab2120"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.24.05" do
    url "https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:291a38fff0ca8431a44b2f0a153d3c41b8b88d049b6e73e5206d28e4c435b458?se=2024-07-17T23%3A35%3A00Z&sig=dJwipWJQsnSEG4rkFi9b87olzkkspJTlqVKUgKJ7InY%3D&sp=r&spr=https&sr=b&sv=2019-12-12"
    sha256 "291a38fff0ca8431a44b2f0a153d3c41b8b88d049b6e73e5206d28e4c435b458"
  end

  def install
    resource("v1.24.05").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.24.05/share", prefix
    mv buildpath/"1.24.05/lib",   prefix
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
