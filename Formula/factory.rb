class Factory < Formula
  desc "C++ class library for recursive representation of multivariate polynomial data"
  homepage "https://github.com/Singular/Singular/blob/spielwiese/factory/README"
  url "https://macaulay2.com/Downloads/OtherSourceCode/factory-4.4.1.tar.gz"
  sha256 "345ec8ab2481135d18244e2a2ff6bc16e812a39a9eb5ac5d578956d8e0526e6e"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 3

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sequoia: "6f57ae01eed9fc70720c8f3cf5753ac33f5c0810de1144853255d95968bc0d76"
    sha256 cellar: :any,                 arm64_sonoma:  "31a30926297f58bab477e790e91b71a8594d684af9101842143b333caa3f83e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3354cceb8411d3cb0e93952e826b9d14d89bbecd712ff5ae4c047e49c1beb3e6"
  end

  keg_only "it conflicts with singular"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "ntl"

  patch :DATA

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

__END__

diff --git a/factory/FLINTconvert.cc b/factory/FLINTconvert.cc
index c36f6022d..a4d86fd17 100644
--- a/FLINTconvert.cc
+++ factory-4.4.1/FLINTconvert.cc
@@ -652,7 +652,7 @@ convertFacCFMatrix2Fq_nmod_mat_t (fq_nmod_mat_t M,
   {
     for(j=m.columns();j>0;j--)
     {
-      convertFacCF2nmod_poly_t (M->rows[i-1]+j-1, m (i,j));
+      convertFacCF2nmod_poly_t (fq_nmod_mat_entry(M, i-1, j-1), m (i,j));
     }
   }
 }
-- 
2.43.0
