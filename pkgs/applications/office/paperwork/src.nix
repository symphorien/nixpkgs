{fetchFromGitLab}:
rec {
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = "cef001481682904697613175fb43ad5a219956d3";
    sha256 = "0394sxnz70wllzdipdzxjzk5mqi04y0k64vcvzf8kvvi8mlklji9";
  };
}
