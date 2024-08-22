class Gfan < Formula
  desc "Grobner fans and tropical varieties"
  homepage "https://users-math.au.dk/~jensen/software/gfan/gfan.html"
  url "https://users-math.au.dk/~jensen/software/gfan/gfan0.7.tar.gz"
  sha256 "ab833757e1e4d4a98662f4aa691394013ea9a226f6416b8f8565356d6fcc989e"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/macaulay2/tap"
    sha256 cellar: :any,                 arm64_sonoma: "f4aa20c4b49233a6c8a68e1a751b783169797764a157d5745f73f8228c41fb62"
    sha256 cellar: :any,                 ventura:      "aa24a98686efeb52abe9fd8c27d5d1a888c9e86303c0e53eec539ee8c195a57c"
    sha256 cellar: :any,                 monterey:     "b92b36b01d8a2187313467b37b21793e34a89e5edd78207e685e8e0e99f23182"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9ad2d53e029a178bd88ba7837fd216ea7b5b46f77648a034a5c7421cfb371555"
  end

  if OS.mac?
    depends_on "gcc" => :build
    fails_with :clang
  else
    fails_with gcc: "4"
    fails_with gcc: "5"
  end

  depends_on "cddlib"
  depends_on "gmp"

  patch :DATA

  def install
    linker_args = "#{ENV.cxx} -L#{Formula["cddlib"].lib} "
    linker_args << "-static-libgcc -static-libstdc++ "
    linker_args << "-ld_classic" if OS.mac? && DevelopmentTools.clang_build_version >= 1500

    system "make", "cddnoprefix=yes",
           "GMP_LINKOPTIONS=-L#{Formula["gmp"].lib} -lgmp",
           "GMP_INCLUDEOPTIONS=-I#{Formula["gmp"].include}",
           "OPTFLAGS=-O2 -DGMPRATIONAL -DNDEBUG -I#{Formula["cddlib"].include}/cddlib",
           "CCLINKER=#{linker_args}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/gfan", "_version"
    pipe_output("#{bin}/gfan _overintegers --groebnerFan", "Q[x,y]\n{x^2-y^2,2*x}\n", 0)
    pipe_output("#{bin}/gfan _tropicalfunction", "Q[x1,x2,x3]\n{x1*x2+x3^2}\n", 0)
    pipe_output("#{bin}/gfan _secondaryfan", "{(1,0),(1,1),(1,2),(1,2)}\n", 0)
  end
end

__END__

diff --git a/Makefile b/Makefile
index 67c8164..0c9bbf2 100644
--- a/Makefile
+++ b/Makefile
@@ -117,11 +117,6 @@ PREFIX =
 SHELL       = /bin/sh
 #ARCH        = LINUX
 
-CC          = $(PREFIX)gcc
-CLINKER     = $(CC)
-CXX         = $(PREFIX)g++
-CCLINKER    = $(CXX)
-
 #CC          = $(PREFIX)gcc-8.1
 #CLINKER     = $(CC)
 #CXX         = $(PREFIX)g++-8.1
@@ -420,9 +415,9 @@ EXECS	  = $(MAIN)
 # (compiling with gcc version 4.7.2 and running gfan _tropicaltraverse on a starting cone for Grassmann3_7)
 # Either this is a bug in the code or in the compiler. The bug disappears by compiling with -fno-guess-branch-probability
 src/symmetrictraversal.o: src/symmetrictraversal.cpp
-	$(CXX) $(CFLAGS) -fno-guess-branch-probability  -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
+#	$(CXX) $(CFLAGS) -fno-guess-branch-probability  -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
 # If compiling with clang, use the line below instead:
-#	$(CXX) $(CFLAGS) -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
+	$(CXX) $(CFLAGS) -c src/symmetrictraversal.cpp -o src/symmetrictraversal.o
 
 # Define suffixes to make the program compile on legolas.imf.au.dk :
 .SUFFIXES: .o .cpp .c
diff --git a/src/application.cpp b/src/application.cpp
index 77f830b..baf3589 100644
--- a/src/application.cpp
+++ b/src/application.cpp
@@ -567,7 +567,7 @@ void Application::makeSymbolicLinks(const char *name, bool all, const char *path
 	if(strlen(p->name())>0)
 	  {
 	    char c[1024];
-	    sprintf(c,"ln -s %s%s %s%s%s\n",path,name,path,name,p->name());
+	    sprintf(c,"ln -sf %s%s %s%s%s\n",path,name,path,name,p->name());
 	    fprintf(stderr,"%s",c);
 	    int err=system(c);
 	    assert(err==0);
diff --git a/src/enumeration.cpp b/src/enumeration.cpp
index 44d0a4f..6d3870e 100644
--- a/src/enumeration.cpp
+++ b/src/enumeration.cpp
@@ -14,7 +14,7 @@ EnumerationFilePrinter::EnumerationFilePrinter():
 
 EnumerationFilePrinter::~EnumerationFilePrinter()
 {
-  assert(file==0);
+  // assert(file==0);
 }
 
 
diff --git a/src/enumeration.h b/src/enumeration.h
index b0bd187..d91c9ff 100644
--- a/src/enumeration.h
+++ b/src/enumeration.h
@@ -36,7 +36,7 @@ class EnumerationFilePrinter: public EnumerationPrinter
   FILE *file;
  public:
   EnumerationFilePrinter();
-  ~EnumerationFilePrinter();
+  virtual ~EnumerationFilePrinter();
 
   void open(std::string filename);
   void open(FILE *file);
diff --git a/src/field.h b/src/field.h
index 866be22..7df1600 100644
--- a/src/field.h
+++ b/src/field.h
@@ -208,6 +208,7 @@ class FieldElementImplementation
   {
 	  fprintf(stderr,"*this is not in Z/pZ.\n");
 	  assert(0);
+	  exit(0);
   }
   virtual bool isInteger()const
   {
@@ -223,6 +224,7 @@ class FieldElementImplementation
   Field& operator=(const Field& a)
     {
       assert(0);
+      exit(1);
     }//assignment
 };
 
@@ -271,7 +273,8 @@ class FieldImplementation
   virtual FieldElement random()
   {
 	  assert(0);
-  }
+	  exit(1);
+       }
     virtual int getCharacteristic()const=0;
     virtual const char *name()=0;
   virtual std::string toString()const=0;
diff --git a/src/field_rationalfunctions2.cpp b/src/field_rationalfunctions2.cpp
index 4e80c5a..ccc6ae9 100644
--- a/src/field_rationalfunctions2.cpp
+++ b/src/field_rationalfunctions2.cpp
@@ -524,6 +524,7 @@ class FieldElementRationalFunction2 : public FieldElementImplementation
 
     return sign+string("{").append(s,startIndex,slashIndex-startIndex)+string("\\over ").append(s,slashIndex+1,s.length()-slashIndex-1)+string("}");
 */
+	  exit(1);
 	  }
 
   std::string toString(bool writeIfOne=true, bool alwaysWriteSign=false, bool latexMode=false /*, bool mathMode=true*/) const
diff --git a/src/field_rationals.cpp b/src/field_rationals.cpp
index 30a92f6..06c95c9 100644
--- a/src/field_rationals.cpp
+++ b/src/field_rationals.cpp
@@ -398,7 +398,7 @@ const char *FieldRationalsImplementation::name()
 /*FieldRationals::FieldRationals():
   Field(new FieldRationalsImplementation())
 {
-  /*  fprintf(Stderr,"Adding field rationals\n");
+  fprintf(Stderr,"Adding field rationals\n");
   next=list;
   list=this;
   */
diff --git a/src/gfanlib_circuittableint.h b/src/gfanlib_circuittableint.h
index 2b5ced4..609d2d2 100644
--- a/src/gfanlib_circuittableint.h
+++ b/src/gfanlib_circuittableint.h
@@ -25,6 +25,7 @@ namespace gfan{
   template<typename> struct MyMakeUnsigned;
   template <> struct MyMakeUnsigned<int>{typedef unsigned int type;};
   template <> struct MyMakeUnsigned<long int>{typedef unsigned long int type;};
+  template <> struct MyMakeUnsigned<long long int>{typedef unsigned long long int type;};
   template <> struct MyMakeUnsigned<__int128>{typedef unsigned __int128 type;};
 
   class MVMachineIntegerOverflow: public std::exception
@@ -239,6 +240,17 @@ static my256s extMul(__int128_t a, __int128_t b)
 	return my256s(r);
 }
 
+static my256s extMul(long long int a, long long int b)
+{
+//	std::cerr<<"mul"<<toStr(a)<<"*"<<toStr(b)<<"\n";
+	auto temp=unsignedProd128(a,b);
+	my256s r(temp.lo,temp.hi);
+	if(a<0)r=r+my256s(0,-b);
+	if(b<0)r=r+my256s(0,-a);
+//	std::cerr<<"result"<<toStr(r)<<"\n";
+	return my256s(r);
+}
+
 /*
  * The philosophy here is that if this class overflows, then the computation needs to be restarted. Therefore
  * all overflows must be caught.
@@ -530,7 +542,7 @@ public:
 		   */
 		  else
 		  {
-			  if(0){
+#if 0
 				  std::cerr<<toStr(positiveResultBoundTimesD)<<"\n"<<toStr(denominatorDivisor.v)<<"\n";
 				  std::cerr<<"---\n";
 				  std::cerr<<toStr(negabs(t).v)<<"\n";
@@ -542,7 +554,7 @@ public:
 				  std::cerr<<"---\n";
 
 //				  std::cerr<<this->)
-			  }
+#endif
 			  int D=std::numeric_limits<word>::digits;
 			  if(D==0){D=127;}//fixes bug in gcc-8.1
 			  bool doesOverflow=(((word)t.v)==(word{1}<<(D-1)));// What is the purpose of this line. Do we really want to subtract 1? That seems wrong since word is signed. Look at comment below
diff --git a/src/gfanlib_z.h b/src/gfanlib_z.h
index f56597c..5a62076 100644
--- a/src/gfanlib_z.h
+++ b/src/gfanlib_z.h
@@ -8,6 +8,7 @@
 #ifndef LIB_Z_H_
 #define LIB_Z_H_
 
+#include <cstdint>
 #include <string.h>
 #include <ostream>
 #include <iostream>
diff --git a/src/gmpallocator.cpp b/src/gmpallocator.cpp
index e308412..07c6b74 100644
--- a/src/gmpallocator.cpp
+++ b/src/gmpallocator.cpp
@@ -29,7 +29,7 @@ static inline int bufNum(int size)
     {
       ret++;
       if(ret>=(NBUCKETSGMP))return -1;
-      size>>1;
+      size>>=1;
     }
   return ret;
 }
diff --git a/src/lp.cpp b/src/lp.cpp
index 744e2a9..420b853 100644
--- a/src/lp.cpp
+++ b/src/lp.cpp
@@ -59,6 +59,7 @@ bool LpSolver::hasInteriorPoint(const IntegerVectorList &g, bool strictlyPositiv
 {
   fprintf(stderr,"hasInteriorPoint method not supported in \"%s\" LP class\n",name());
   assert(0);
+  exit(1);
 }
 
 
@@ -119,6 +120,7 @@ bool LpSolver::hasHomogeneousSolution(int n, const IntegerVectorList &inequaliti
 {
   fprintf(stderr,"hasHomogeneousSolution method not supported in \"%s\" LP class\n",name());
   assert(0);
+  exit(1);
 }
 
 static LpSolver *soplex,*soplexCddGmp,*huber,*cdd,*cddgmp,*default_;
diff --git a/src/nbody.cpp b/src/nbody.cpp
index e6d2e6e..3384bb0 100644
--- a/src/nbody.cpp
+++ b/src/nbody.cpp
@@ -17,6 +17,7 @@ static int rIndex(int i, int j, int N, bool withMasses)
 	r++;
       }
   assert(0);
+  exit(1);
 }
 
 static int sIndex(int i, int j, int N, bool withMasses)
diff --git a/src/packedmonomial.cpp b/src/packedmonomial.cpp
index 65a9242..37404e6 100644
--- a/src/packedmonomial.cpp
+++ b/src/packedmonomial.cpp
@@ -39,6 +39,7 @@ vector<MonomialType> minimized(vector<MonomialType> const &generators)
 
 	  *g=ret;
 */
+	exit(1);
 }
 
 
diff --git a/src/parser.cpp b/src/parser.cpp
index 8c09b1a..ed807f8 100644
--- a/src/parser.cpp
+++ b/src/parser.cpp
@@ -638,6 +638,7 @@ Field CharacterBasedParser::parseField()
 
   parserError("field",c);
   assert(0);
+  exit(1);
 }
 
 
diff --git a/src/polyhedralfan.cpp b/src/polyhedralfan.cpp
index e62cae4..90eae40 100644
--- a/src/polyhedralfan.cpp
+++ b/src/polyhedralfan.cpp
@@ -1672,6 +1672,7 @@ PolyhedralCone PolyhedralFan::coneContaining(IntegerVector const &v)const
     if(i->contains(v))return i->faceContaining(v);
   debug<<"Vector "<<v<<" not contained in support of fan\n";
   assert(0);
+  exit(1);
 }
 
 
diff --git a/src/polymakefile.cpp b/src/polymakefile.cpp
index a7ea692..55d3d39 100644
--- a/src/polymakefile.cpp
+++ b/src/polymakefile.cpp
@@ -329,6 +329,7 @@ void PolymakeFile::writeMatrixProperty(const char *p, const IntegerMatrix &m, bo
 IntegerMatrix PolymakeFile::readArrayArrayIntProperty(const char *p, int width)
 {
   assert(0);//Not implemented yet.
+  exit(1);
 }
 
 
@@ -371,7 +372,7 @@ static list<int> readIntList(istream &s)
 {
   list<int> ret;
   int c=s.peek();
-  while((c>='0') && (c<='9')|| (c==' '))
+  while(((c>='0') && (c<='9'))|| (c==' '))
     {
       //      fprintf(Stderr,"?\n");
       int r;
diff --git a/src/polynomialgcd.cpp b/src/polynomialgcd.cpp
index 82aea06..14cb528 100644
--- a/src/polynomialgcd.cpp
+++ b/src/polynomialgcd.cpp
@@ -618,7 +618,7 @@ Polynomial NonMonomialPolynomialGCDForZ(PolynomialSet p)
 if(1)	{
 		static int i;
 		i++;
-		if((i==1000))
+		if(i==1000)
 		{
 //			debug<<simplifyPolysViaHomogeneitySpace(p);
 //			debug<<"NonMon on:"<<p.getRing()<<p<<"\n";
diff --git a/src/timer.cpp b/src/timer.cpp
index 7421c41..b5d8741 100644
--- a/src/timer.cpp
+++ b/src/timer.cpp
@@ -1,10 +1,10 @@
 #include "timer.h"
-#include "log.h"
-
 #include "iostream"
 #include <time.h>
 #include <assert.h>
 
+#include "log.h" // include last, because it defines a macro "log2" also defined as a function in math.h
+
 using namespace std;
 
 Timer* Timer::timers;
diff --git a/src/vektor.cpp b/src/vektor.cpp
index d17579a..63e39f0 100644
--- a/src/vektor.cpp
+++ b/src/vektor.cpp
@@ -96,7 +96,7 @@ int gcdGFAN(int r, int s)
 int gcdOfVector(IntegerVector const &v)
 {
   int ret=0;
-  for(int i=0;i<v.size();i++)if(ret=v[i])break;
+  for(int i=0;i<v.size();i++)if((ret=v[i]))break;
   if(ret<0)ret=-ret;
   assert(ret!=0);
   for(int i=0;i<v.size();i++)ret=gcdGFAN(ret,v[i]);
-- 
2.46.0
