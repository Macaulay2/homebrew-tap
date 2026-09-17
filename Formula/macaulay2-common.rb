class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "ae882ab04da19f62c62462ef9604251a0b30a9f5"
  version "1.26.06"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7331e51cbac2923904e0b640c8a3fe075dff95c1756f8479d581b277f1254d23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a1e15b26bc21d360e1f33e697d01e9ea38552659a044e10b93a89b4c1dc351"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5495ad7ea5d7daaaac17ba5dc94e037e187c563c11516b042bafffec27ac2de"
    sha256 cellar: :any_skip_relocation, sequoia:       "17a2e82b6096cb7dc2b18d796f5a2d28d96b2cfdf8dae30965ef4c03a6cb1daf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08419987878c2d0aafa69d85620af0b1f76342d25c39d98f1a583a5d6deeba1"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.26.06" do
    url "https://ghcr.io/v2/macaulay2/tap/macaulay2/blobs/sha256:10c7e99660344f82945ad450bdef35b9665bffef15c986f24b805a7ea8d78dee",
        header: "Authorization: Bearer QQ=="
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

  post_install_steps do
    if_path_exists "{{HOMEBREW_PREFIX}}/opt/macaulay2" do
      copy "share", "{{HOMEBREW_PREFIX}}/opt/macaulay2", recursive: true
      copy "lib", "{{HOMEBREW_PREFIX}}/opt/macaulay2", recursive: true
    end
    unless_path_exists "{{HOMEBREW_PREFIX}}/opt/macaulay2" do
      warn <<~EOS
        No version of Macaulay2 was found; run:
          brew install macaulay2 --HEAD
        to build Macaulay2 from source, then add the common documentation files with:
          brew postinstall macaulay2-common
      EOS
    end
  end

  test do
    system "true"
  end
end
