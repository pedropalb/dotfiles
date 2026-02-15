{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "pedropalb";
        email = "pedro17lopes@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
