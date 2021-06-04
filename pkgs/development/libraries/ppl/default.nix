{ fetchurl
, fetchpatch
, lib
, stdenv
, gmpxx
, perl
, gnum4
, jdk ? null
, javaBindings ? false
}:

let version = "1.2"; in

stdenv.mkDerivation {
  pname = "ppl";
  inherit version;

  src = fetchurl {
    url = "http://bugseng.com/products/ppl/download/ftp/releases/${version}/ppl-${version}.tar.bz2";
    sha256 = "1wgxcbgmijgk11df43aiqfzv31r3bkxmgb4yl68g21194q60nird";
  };

  patches = [(fetchpatch {
    name = "clang5-support.patch";
    url = "https://git.sagemath.org/sage.git/plain/build/pkgs/ppl/patches/clang5-support.patch?h=9.2";
    sha256 = "1zj90hm25pkgvk4jlkfzh18ak9b98217gbidl3731fdccbw6hr87";
  })];

  nativeBuildInputs = [ perl gnum4 ]
    ++ lib.optional javaBindings jdk;
  propagatedBuildInputs = [ gmpxx ];

  configureFlags = [
    "--enable-instantiations=all"
    "CPPFLAGS=-fexeceptions"
    "LDFLAGS=-znoexecstack"
  ] ++ lib.optional stdenv.isDarwin [
    "--disable-ppl_lcdd"
    "--disable-ppl_lpsol"
    "--disable-ppl_pips"
  ] ++ lib.optional javaBindings [
    "--enable-interfaces=java"
    "--with-java=${jdk}"
  ];

  # Beware!  It took ~6 hours to compile PPL and run its tests on a 1.2 GHz
  # x86_64 box.  Nevertheless, being a dependency of GCC, it probably ought
  # to be tested.
  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    description = "The Parma Polyhedra Library";

    longDescription = ''
      The Parma Polyhedra Library (PPL) provides numerical abstractions
      especially targeted at applications in the field of analysis and
      verification of complex systems.  These abstractions include convex
      polyhedra, defined as the intersection of a finite number of (open or
      closed) halfspaces, each described by a linear inequality (strict or
      non-strict) with rational coefficients; some special classes of
      polyhedra shapes that offer interesting complexity/precision tradeoffs;
      and grids which represent regularly spaced points that satisfy a set of
      linear congruence relations.  The library also supports finite
      powersets and products of (any kind of) polyhedra and grids and a mixed
      integer linear programming problem solver using an exact-arithmetic
      version of the simplex algorithm.
    '';

    homepage = "http://bugseng.com/products/ppl/";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
