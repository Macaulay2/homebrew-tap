class Phcpack < Formula
  desc "Software package for solving polynomial systems with homotopy continuation"
  homepage "https://github.com/janverschelde/PHCpack"
  url "https://github.com/janverschelde/PHCpack/archive/refs/tags/v2.4.90.tar.gz"
  sha256 "7db1529b019a24e6fc2217ecccbcf3aa56f1b098bbe2f75e834f415e58c8bde7"
  license "GPL-3.0-only"

  depends_on "qd"

  def install
    system "make", "-j", "-C", "src/Objects", "-f", "makefile_unix", "phc"
    system "make", "-j", "-C", "src/Objects", "-f", "makefile_unix", "install"
  end

  test do
    system "true"
  end
end
