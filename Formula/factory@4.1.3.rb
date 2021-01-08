class FactoryAT413 < Formula
  desc "C++ class library for recursive representation of multivariate polynomial data"
  homepage "https://github.com/Singular/Singular/blob/spielwiese/factory/README"
  url "https://faculty.math.illinois.edu/Macaulay2/Downloads/OtherSourceCode/factory-4.1.3.tar.gz"
  sha256 "d004dd7e3aafc9881b2bf42b7bc935afac1326f73ad29d7eef0ad33eb72ee158"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 2

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/factory@4.1.3-4.1.3_2"
    sha256 "e682b69396558d1720e01d934012e9f5c09feef4822b47215a29e50a1829643e" => :catalina
    sha256 "e8d2c661c86de3829908ce25ac0930312de582a8ffaad65cbbf8bf8638d705df" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
  end

  depends_on "flint@2.6.3"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    ENV.cxx11
    ENV["CPPFLAGS"] = "-DNDEBUG -DOM_NDEBUG -DSING_NDEBUG"
    ENV["CXXFLAGS"] = "-std=c++11"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-doxygen-doc
      --disable-silent-rules
      --disable-omalloc
      --enable-streamio
      --without-Singular
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --with-flint=#{Formula["flint@2.6.3"].prefix}
      --prefix=#{prefix}
    ]
    system "autoreconf", "-vif"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # test that the library is installed and linkable-against
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
    system ENV.cxx, "test.cc", "-I#{include}/factory", "-L#{lib}", "-lfactory",
           "-L#{Formula["flint@2.6.3"].lib}", "-lflint",
           "-L#{Formula["ntl"].lib}", "-lntl",
           "-L#{Formula["mpfr"].lib}", "-lmpfr",
           "-L#{Formula["gmp"].lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end
