class Givaro < Formula
  desc "Prime field and algebraic computations"
  homepage "https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
  url "https://github.com/linbox-team/givaro/releases/download/v4.2.1/givaro-4.2.1.tar.gz"
  sha256 "feefb7445842ceb756f8bb13900d975b530551e488a2ae174bda7b636251de43"
  license "CECILL-B"

  head "https://github.com/linbox-team/givaro.git", using: :git

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "67ffb3653f3bcb57157254e433abc3f9d12ce43dbc0caa06ad1f49c310a7249b"
    sha256 cellar: :any,                 arm64_sonoma:  "3f833333dd2b5a1ddd03bd408718361839aa51e15a85b18d3b2547c910f16e88"
    sha256 cellar: :any,                 ventura:       "a162ae1c53c769821687c7871fe1571250a83da031dfc50296b7af7171c7b14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418fccc9c8c58d610efbf5519f79c4fe1bc31f1c203ea36564af4c09f9ae9614"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gmp"

  def install
    ENV.cxx11
    system "autoreconf", "-vif"
    system "./configure",
           "--with-gmp=#{Formula["gmp"].prefix}",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
