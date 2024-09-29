{ ... }:
{

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        example2 = pkgs.callPackage ../pkgs/example2 { };
        jdnbtexplorer = pkgs.callPackage ../pkgs/jdnbtexplorer { };
        nbt = pkgs.callPackage ../pkgs/nbt { };
      };
    };
}
  