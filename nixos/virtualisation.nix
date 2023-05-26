{ config, pkgs, ...}:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.virt-manager unstable.virt-viewer
    unstable.spice unstable.spice-gtk unstable.spice-protocol
    unstable.win-virtio unstable.win-spice
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.unstable.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
