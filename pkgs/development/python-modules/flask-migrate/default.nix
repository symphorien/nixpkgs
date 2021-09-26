{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, glibcLocales, flask, flask_sqlalchemy, flask_script, alembic }:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "3.1.0";

  # pypi archive is missing tests/custom_template
  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-Migrate";
    rev = "v${version}";
    sha256 = "0zj7qpknvlhrh4fsp5sx4fwyx3sp41ynclka992zympm3xym9zyq";
  };

  checkInputs = [ flask_script ] ++ lib.optional isPy3k glibcLocales;
  propagatedBuildInputs = [ flask flask_sqlalchemy alembic ];

  # tests invoke the flask cli which uses click and therefore has py3k encoding troubles
  preCheck = lib.optionalString isPy3k ''
    export LANG="en_US.UTF-8"
  '';

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    license = licenses.mit;
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
  };
}
