{fetchFromGitLab}:
rec {
  version = "2.2.0";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = "8ea9b1903a81667b2816fc8ea9d62ad1d359a193";
    sha256 = "sha256-P+fIfYlvNpiIzAIUTH0S1vJ65yS1YDTp+hzAV0fMUAw=";
  };
  sample_documents = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork-test-documents";
    group = "World";
    owner = "OpenPaperwork";
    # https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/blob/master/paperwork-gtk/src/paperwork_gtk/model/help/screenshot.sh see TEST_DOCS_TAG
    rev = "2.1";
    sha256 = "0m79fgc1ycsj0q0alqgr0axn16klz1sfs2km1h83zn3kysqcs6xr";
  };

}
