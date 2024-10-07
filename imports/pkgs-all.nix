{ ... }:
{

  perSystem =
    { pkgs, pkgs-stable,  ... }:
    {
      packages = {
        jdnbtexplorer = pkgs.callPackage ../pkgs/jdnbtexplorer { };
        nbt = pkgs.callPackage ../pkgs/nbt { };
        biglybt = pkgs.callPackage ../pkgs/biglybt { };
        torzu = pkgs.callPackage ../pkgs/torzu { };
        sudachi = pkgs.callPackage ../pkgs/sudachi { };
      };
    };
}
  