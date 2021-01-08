class FlintAT263 < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.6.3.tar.gz"
  sha256 "ce1a750a01fa53715cad934856d4b2ed76f1d1520bac0527ace7d5b53e342ee3"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    root_url "https://github.com/mahrud/homebrew-tap/releases/download/flint@2.6.3-2.6.3"
    sha256 "36f0d62611113c0305e20a5f48e1d335001d9e5aea5002e5a7233ef529845dcf" => :catalina
    sha256 "99c1eca00be8ba0a92f55952eb53b6ac0b7d1c45804ad7f2f7c8a923665ea892" => :x86_64_linux
  end

  unless OS.mac?
    fails_with gcc: "4"
    fails_with gcc: "5"
    depends_on "gcc@9" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    ENV.cxx11
    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <stdlib.h>
      #include <stdio.h>

      #include <flint/flint.h>
      #include <flint/fmpz_mod_poly.h>

      int main(int argc, char* argv[])
      {
          fmpz_t n;
          fmpz_mod_poly_t x, y;

          fmpz_init_set_ui(n, 7);
          fmpz_mod_poly_init(x, n);
          fmpz_mod_poly_init(y, n);
          fmpz_mod_poly_set_coeff_ui(x, 3, 5);
          fmpz_mod_poly_set_coeff_ui(x, 0, 6);
          fmpz_mod_poly_sqr(y, x);
          fmpz_mod_poly_print(x); flint_printf("\\n");
          fmpz_mod_poly_print(y); flint_printf("\\n");
          fmpz_mod_poly_clear(x);
          fmpz_mod_poly_clear(y);
          fmpz_clear(n);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test"
  end
end
