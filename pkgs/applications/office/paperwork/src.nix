{fetchFromGitLab}:
rec {
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = "bbd22d9db0d2950080fe05d77c9c2cb23e0bd88d";
    sha256 = "13kyfwha9bmgiw66d84qyv075wy8wc28x9i6rjwv69mz0j9q7dm4";
  };
}
