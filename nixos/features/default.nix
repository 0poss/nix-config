{
  locale = import ./locale.nix;
  nixpkgs = import ./nixpkgs.nix;
  pipewire = import ./pipewire.nix;
  standard-disk-layout = import ./standard-disk-layout.nix;
  wayland = import ./wayland.nix;
  wireless = import ./wireless.nix;
}
