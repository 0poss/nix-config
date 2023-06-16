{ pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/hardened.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_1_hardened;
  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_alloc.shuffle=1"
    "pti=on"
    "randomize_kstack_offset=on"
    "vsyscall=none"
    "debugfs=off"
    "oops=panic"
    "quiet"
    "loglevel=0"
  ];

  systemd.coredump.enable = false;

  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
    "dev.tty.ldisc_autoload" = 0;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.icmp_echo_ignore_all" = 1;
    "net.ipv6.icmp_echo_ignore_all" = 1;
    "net.ipv4.tcp_sack" = 0;
    "net.ipv4.tcp_dsack" = 0;
    "net.ipv4.tcp_fack" = 0;
    "kernel.yama.ptrace_scope" = 2;
  };
}
