{fetchFromGitLab}:
rec {
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = "83f134d0da4703ae8834fd9379f844256c94ccd7";
    sha256 = "0q86pci0hcp3wl6bq123qz574a4fs1n3dyhvczg0s1riq1cz0m07";
  };
}
