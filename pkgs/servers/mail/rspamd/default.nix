{ stdenv, lib, fetchFromGitHub, cmake, perl, fetchpatch
, glib, luajit, openssl, pcre, pkgconfig, sqlite, ragel, icu
, hyperscan, jemalloc, openblas, lua, libsodium
, withBlas ? true
, withHyperscan ? stdenv.isx86_64
, withLuaJIT ? stdenv.isx86_64
}:

assert withHyperscan -> stdenv.isx86_64;

stdenv.mkDerivation rec {
  pname = "rspamd";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "rspamd";
    repo = "rspamd";
    rev = version;
    sha256 = "0rqiz4xm20w80q8p4grcgqcrg14yiddsay0aw00f0v82h4apw7k8";
  };

  patches = [
    # dependency of the next patch
    (fetchpatch {
      url = "https://github.com/rspamd/rspamd/commit/3b5628dc30170d27b4f6ed956ce523bf216fa0f5.patch";
      sha256 = "1v51m7qw5d7mjhqzyjz0dsxdyfajan8lxrrj16yszjxlbnzicvz3";
    })
    # fixes https://github.com/rspamd/rspamd/issues/2611 as triggered by the simple nixos mailserver test suite
    (fetchpatch {
      url = "https://github.com/rspamd/rspamd/commit/f514841c75aae5c8dfc3a8e4fba409a70424517f.patch";
      sha256 = "11sb15rkhlga3xlv9cv3p9s8x60sv85i2vmxd5lh1lp6ggy29z8k";
    })
  ];

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ glib openssl pcre sqlite ragel icu jemalloc libsodium ]
    ++ lib.optional withHyperscan hyperscan
    ++ lib.optional withBlas openblas
    ++ lib.optional withLuaJIT luajit ++ lib.optional (!withLuaJIT) lua;

  cmakeFlags = [
    "-DDEBIAN_BUILD=ON"
    "-DRUNDIR=/run/rspamd"
    "-DDBDIR=/var/lib/rspamd"
    "-DLOGDIR=/var/log/rspamd"
    "-DLOCAL_CONFDIR=/etc/rspamd"
    "-DENABLE_JEMALLOC=ON"
  ] ++ lib.optional withHyperscan "-DENABLE_HYPERSCAN=ON";

  meta = with stdenv.lib; {
    homepage = "https://rspamd.com";
    license = licenses.asl20;
    description = "Advanced spam filtering system";
    maintainers = with maintainers; [ avnik fpletz globin ];
    platforms = with platforms; linux;
  };
}
