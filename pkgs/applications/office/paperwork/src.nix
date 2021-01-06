{fetchFromGitLab}:
rec {
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = "6dfbca1c9dcd5cfa0f25f7e0c00c0a01e0eb3c7a";
    sha256 = "1raj2h3rd81pq3giqnc50nk2ir4mysnngjq0jn5s0ccslmxcawby";
  };
}
