class Linbox < Formula
  desc "Finite Field Linear Algebra Routines"
  homepage "https://linalg.org/"
  url "https://github.com/linbox-team/linbox/releases/download/v1.7.0/linbox-1.7.0.tar.gz"
  sha256 "6d2159fd395be0298362dd37f6c696676237bc8e2757341fbc46520e3b466bcc"
  license "LGPL-2.1-or-later"
  revision 2

  head "https://github.com/linbox-team/linbox.git", using: :git, branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "fflas-ffpack"
  depends_on "flint"
  depends_on "givaro"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "ntl"
  depends_on "openblas" unless OS.mac?

  patch do
    url "https://github.com/linbox-team/linbox/commit/d1f618fb0ee4a84be3ccddcfc28b257f34e1cbf7.patch?full_index=1"
    sha256 "17241e1ed8937c1aa3d2fa839ee981332ce393f5c4f7c61784021064fc7f258a"
  end

  patch do
    url "https://github.com/linbox-team/linbox/commit/4a1e1395804d4630ec556c61ba3f2cb67e140248.patch?full_index=1"
    sha256 "63dc9e7cb178ea4498f6168534563a2fb4edae37b30997ecf3c250621d86cd94"
  end

  # linbox PR 310 - with diff of 1 file removed due to patch not applying cleanly
  #                 only comments chaged in that file, anyway.
  # linbox PRs 320, 322
  patch :DATA

  def install
    ENV.cxx11
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OMPFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    else
      ENV["OMPFLAGS"] = "-fopenmp"
    end
    ENV["CBLAS_LIBS"] = ENV["LIBS"] = OS.mac? ? "-framework Accelerate" : "-lopenblas"
    system "autoreconf", "-vif"
    system "./configure",
           "--enable-openmp",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
__END__
diff --git a/linbox/blackbox/block-hankel.h b/linbox/blackbox/block-hankel.h
index a4bc7bf..c8e2756 100644
--- a/linbox/blackbox/block-hankel.h
+++ b/linbox/blackbox/block-hankel.h
@@ -345,8 +345,8 @@ namespace LinBox
 		template<class Vector1, class Vector2>
 		Vector1& apply(Vector1 &x, const Vector2 &y) const
 		{
-			linbox_check(this->_coldim == y.size());
-			linbox_check(this->_rowdim == x.size());
+			linbox_check(this->coldim() == y.size());
+			linbox_check(this->rowdim() == x.size());
 			BlasMatrixDomain<Field> BMD(field());
 #ifdef BHANKEL_TIMER
 			_chrono.clear();
diff --git a/linbox/matrix/sparsematrix/sparse-ell-matrix.h b/linbox/matrix/sparsematrix/sparse-ell-matrix.h
index 59006d6..ced23a5 100644
--- a/linbox/matrix/sparsematrix/sparse-ell-matrix.h
+++ b/linbox/matrix/sparsematrix/sparse-ell-matrix.h
@@ -1205,20 +1205,6 @@ namespace LinBox
 				, _row(iter._row)
 			{}
 
-			_IndexedIterator &operator = (const _IndexedIterator &iter)
-			{
-				_colid_beg = iter._colid_beg ;
-				_colid_it  = iter._colid_it ;
-				_data_it   = iter._data_it  ;
-				_data_beg  = iter._data_beg ;
-				_data_end  = iter._data_end  ;
-				_field     = iter._field ;
-				_ld        = iter._ld ;
-				_row       = iter._row ;
-
-				return *this;
-			}
-
 			bool operator == (const _IndexedIterator &i) const
 			{
 				// we assume consistency
diff --git a/linbox/matrix/sparsematrix/sparse-ellr-matrix.h b/linbox/matrix/sparsematrix/sparse-ellr-matrix.h
index 498a552..359cb15 100644
--- a/linbox/matrix/sparsematrix/sparse-ellr-matrix.h
+++ b/linbox/matrix/sparsematrix/sparse-ellr-matrix.h
@@ -1099,19 +1099,6 @@ namespace LinBox
 
 			{}
 
-			_Iterator &operator = (const _Iterator &iter)
-			{
-				_data_it  = iter._data_it  ;
-				_data_beg  = iter._data_beg  ;
-				_data_end  = iter._data_end  ;
-				_field  = iter._field  ;
-				_rowid = iter._rowid;
-				_ld = iter._ld ;
-				_row = iter._row ;
-
-				return *this;
-			}
-
 			bool operator == (const _Iterator &i) const
 			{
 				return  (_data_it == i._data_it) ;
@@ -1246,21 +1233,6 @@ namespace LinBox
 				, _row(iter._row)
 			{}
 
-			_IndexedIterator &operator = (const _IndexedIterator &iter)
-			{
-				_rowid_it  = iter._rowid_it ;
-				_colid_beg = iter._colid_beg ;
-				_colid_it  = iter._colid_it ;
-				_data_it   = iter._data_it  ;
-				_data_beg  = iter._data_beg ;
-				_data_end  = iter._data_end  ;
-				_field     = iter._field ;
-				_ld        = iter._ld ;
-				_row       = iter._row ;
-
-				return *this;
-			}
-
 			bool operator == (const _IndexedIterator &i) const
 			{
 				// we assume consistency
diff --git a/linbox/ring/ntl/ntl-lzz_p.h b/linbox/ring/ntl/ntl-lzz_p.h
index 201baaa..1bf8fc8 100644
--- a/linbox/ring/ntl/ntl-lzz_p.h
+++ b/linbox/ring/ntl/ntl-lzz_p.h
@@ -145,6 +145,11 @@ namespace LinBox
 			,zero( NTL::to_zz_p(0)),one( NTL::to_zz_p(1)),mOne(-one)
             {}
 
+		Element &init (Element &x) const
+            {
+                return x = NTL::to_zz_p(0);
+            }
+
 		Element& init(Element& x, const double& y) const
             {
                 double z = fmod(y,(double)Element::modulus());
@@ -153,7 +158,7 @@ namespace LinBox
                 return x = NTL::to_zz_p(static_cast<long>(z)); //rounds towards 0
             }
 
-		Element &init (Element &x, const integer &y=0) const
+		Element &init (Element &x, const integer &y) const
             {
                 NTL::ZZ tmp= NTL::to_ZZ(std::string(y).data());
                 return x = NTL::to_zz_p(tmp);
diff --git a/linbox/ring/ntl/ntl-lzz_pe.h b/linbox/ring/ntl/ntl-lzz_pe.h
index 60b132a..045b2f7 100644
--- a/linbox/ring/ntl/ntl-lzz_pe.h
+++ b/linbox/ring/ntl/ntl-lzz_pe.h
@@ -207,7 +207,9 @@ namespace LinBox
 			return f;
             }
 
-		Element & init(Element & x, integer n = 0) const
+		Element & init(Element & x) const { return x; }
+
+		Element & init(Element & x, integer n) const
             {   // assumes n >= 0.
                 int e = exponent();
                 n %= cardinality();
diff --git a/linbox/ring/ntl/ntl-zz_px.h b/linbox/ring/ntl/ntl-zz_px.h
index 6e7d5b2..340df9f 100644
--- a/linbox/ring/ntl/ntl-zz_px.h
+++ b/linbox/ring/ntl/ntl-zz_px.h
@@ -104,6 +104,12 @@ namespace LinBox
 			,_CField(cf)
 		{}
 
+		/** Initialize p to 0 */
+		Element& init( Element& p ) const
+		{
+			return p = 0;
+		}
+
 		/** Initialize p to the constant y (p = y*x^0) */
 		template <class ANY>
 		Element& init( Element& p, const ANY& y ) const
