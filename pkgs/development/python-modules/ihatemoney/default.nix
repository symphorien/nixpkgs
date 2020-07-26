{ buildPythonPackage, lib, fetchFromGitHub, isPy27, nixosTests, fetchpatch, fetchPypi
, alembic
, aniso8601
, Babel
, blinker
, click
, cachetools
, dnspython
, email_validator
, flask
, flask-babel
, flask-cors
, flask_mail
, flask_migrate
, flask-restful
, flask_script
, flask_sqlalchemy
, flask_wtf
, debts
, idna
, itsdangerous
, jinja2
, Mako
, markupsafe
, python-dateutil
, pytz
, requests
, six
, sqlalchemy
, sqlalchemy-continuum
, werkzeug
, wtforms
, psycopg2 # optional, for postgresql support
, flask_testing
}:

# ihatemoney is not really a library. It will only ever be imported
# by the interpreter of uwsgi. So overrides for its depencies are fine.
let
  # https://github.com/spiral-project/ihatemoney/issues/567
  pinned_wtforms = wtforms.overridePythonAttrs (old: rec {
    pname = "WTForms";
    version = "2.2.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0q9vkcq6jnnn618h27lx9sas6s9qlg2mv8ja6dn0hy38gwzarnqc";
    };
  });
  pinned_flask_wtf = flask_wtf.override { wtforms = pinned_wtforms; };
in

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "spiral-project";
    repo = pname;
    rev = "master";
    sha256 = "1qrh8352nyk22yxp15ckxyyk0by1r4s1f6l5mvk4yj4nmgkcyrjs";
  };

  disabled = isPy27;

  propagatedBuildInputs = [
    alembic
    aniso8601
    Babel
    blinker
    click
    cachetools
    dnspython
    email_validator
    flask
    flask-babel
    flask-cors
    flask_mail
    flask_migrate
    flask-restful
    flask_script
    flask_sqlalchemy
    pinned_flask_wtf
    idna
    itsdangerous
    jinja2
    Mako
    markupsafe
    python-dateutil
    pytz
    requests
    six
    sqlalchemy
    sqlalchemy-continuum
    werkzeug
    pinned_wtforms
    psycopg2
    debts
  ];

  checkInputs = [
    flask_testing
  ];

  passthru.tests = {
    inherit (nixosTests) ihatemoney;
  };
  meta = with lib; {
    homepage = "https://ihatemoney.org";
    description = "A simple shared budget manager web application";
    platforms = platforms.linux;
    license = licenses.beerware;
    maintainers = [ maintainers.symphorien ];
  };
}


