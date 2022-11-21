{
  libyaml,
  pcre2,
  universal-ctags,
}:
universal-ctags.overrideAttrs (oldAttrs: {
  buildInputs = oldAttrs.buildInputs ++ [libyaml pcre2];
  doCheck = false;
})
