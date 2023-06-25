{ pkgs, lib, ... }:

with lib;

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_1_hardened;
    kernelParams = [
      "slub_debug=FZP"
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "page_alloc.shuffle=1"
      "page_poison=1"
      "pti=on"
      "randomize_kstack_offset=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "quiet"
      "loglevel=0"
    ];
    kernel.sysctl = {
      "kernel.printk" = mkOverride 500 "3 3 3 3";
      "kernel.kptr_restrict" = mkOverride 500 2;
      "kernel.ftrace_enabled" = mkDefault false;
      "kernel.core.bpf_jit_enable" = mkDefault true;
      "dev.tty.ldisc_autoload" = mkDefault 0;
      "net.ipv4.tcp_rfc1337" = mkDefault 1;
      "net.ipv4.icmp_echo_ignore_all" = mkDefault 1;
      "net.ipv6.icmp_echo_ignore_all" = mkDefault 1;
      "net.ipv4.tcp_sack" = mkDefault 0;
      "net.ipv4.tcp_dsack" = mkDefault 0;
      "net.ipv4.tcp_fack" = mkDefault 0;
      "kernel.yama.ptrace_scope" = mkOverride 500 2;
    };
  };

  systemd.coredump.enable = false;

  security = {
    apparmor = {
      enable = mkDefault true;
      killUnconfinedConfinables = mkDefault true;
    };

    lockKernelModules = mkDefault true;
    protectKernelImage = mkDefault true;
    forcePageTableIsolation = mkDefault true;
    virtualisation.flushL1DataCache = mkDefault "always";
  };
}