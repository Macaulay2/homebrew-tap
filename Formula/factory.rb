class Factory < Formula
  desc "C++ class library for recursive representation of multivariate polynomial data"
  homepage "https://github.com/Singular/Singular/blob/spielwiese/factory/README"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Factory/factory-4.4.0.tar.gz"
  sha256 "baf31159578463e26bf18ec68ec901228d79a819866dd96c02d85c73dfbaf030"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sonoma: "8e3cf499ddc55d4cd5adce608c514a0cfff0385febebd7338385f15adc3f63eb"
    sha256 cellar: :any,                 ventura:      "c4c8adac59e5cb86a2241dfc1cfca3a8a7042bc2163df3e35bbfe2e1236dbb07"
    sha256 cellar: :any,                 monterey:     "67c2a620b47efc30d003f03ef040ca2ec0e8554867db829304268a23f242da59"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfce24efc1564e07f559c2b6511853237d1122a17a619442a56adaa4f0e3c602"
  end

  keg_only "it conflicts with singular"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "ntl"

  def install
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-doxygen-doc
      --disable-silent-rules
      --disable-omalloc
      --without-Singular
      --with-gmp=#{Formula["gmp"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --with-flint=#{Formula["flint"].prefix}
      --prefix=#{prefix}
      CXXFLAGS=-std=c++11
    ]
    system "autoreconf", "-vif"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # also check:
    #  grep [[^.define HAVE_NTL 1]] _config.h
    #  grep [[^.define HAVE_FLINT 1]] _config.h
    (testpath/"test.cc").write <<-EOS
        #include "factory/factory.h"

        int main()
        {
	  Off (SW_USE_EZGCD);
	  Off (SW_USE_CHINREM_GCD);

          int p = 101;
	  int ret = 0;
	  setCharacteristic (p);
	  CanonicalForm d1= Variable (1) + Variable (2) + 1;
	  CanonicalForm f1= Variable (1) - Variable (2) - 2;
	  CanonicalForm g1= Variable (1) + Variable (2) + 2;
	  CanonicalForm d= power (d1, 2);
	  CanonicalForm f= d* power (f1, 2);
	  CanonicalForm g= d* power (g1, 2);
	  CanonicalForm h= gcd (f,g);
	  h /= Lc (h);
	  if (h != d)
	    ret = -1;
	  for (int i= 3; i <= 7; i++)
	    {
	      d1 += power (Variable (i), i);
	      f1 -= power (Variable (i), i);
	      g1 += power (Variable (i), i);
	      d= power (d1, 2);
	      f= d*power (f1, 2);
	      g= d*power (g1, 2);
	      h= gcd (f,g);
	      h /= Lc (h);
	      if (h != d)
		ret = -1;
	    }
	  return ret;
	}
    EOS
    system ENV.cxx, "test.cc", "-I#{include}", "-L#{lib}", "-lfactory",
           "-L#{Formula["flint"].lib}", "-lflint",
           "-L#{Formula["ntl"].lib}", "-lntl",
           "-L#{Formula["gmp"].lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
