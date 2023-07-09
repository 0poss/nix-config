{ pkgs, lib, ... }:

with lib;

{
  boot = {

    # Basically linuxPackages_X_X_hardened but with ignoreConfigErrors = true and compiled with clang.
    kernelPackages = pkgs.linuxPackagesFor (
      pkgs.linux_6_1_hardened.override {
        stdenv = pkgs.llvmPackages_11.stdenv;
        ignoreConfigErrors = true;
      });

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

    kernelPatches = lib.mkForce [
      {
        name = "oposs";
        patch = null;
        extraStructuredConfig = with lib.kernel; {
          WERROR = lib.mkForce yes;
          X86_KERNEL_IBT = lib.mkForce yes;
          DEBUG_VIRTUAL = lib.mkForce yes;
          INIT_ON_ALLOC_DEFAULT_ON = lib.mkForce yes;
          ZERO_CALL_USED_REGS = lib.mkForce yes;
          RANDSTRUCT_PERFORMANCE = lib.mkForce yes;
          INIT_ON_FREE_DEFAULT_ON = lib.mkForce yes;
          EFI_DISABLE_PCI_DMA = lib.mkForce yes;
          RESET_ATTACK_MITIGATION = lib.mkForce yes;
          UBSAN = lib.mkForce yes;
          UBSAN_BOUNDS = lib.mkForce yes;
          UBSAN_LOCAL_BOUNDS = lib.mkForce yes;
          USBAN_TRAP = lib.mkForce yes;
          UBSAN_SANITIZE_ALL = lib.mkForce yes;
          CFI_CLANG = lib.mkForce yes;
          IOMMU_DEFAULT_DMA_STRUCT = lib.mkForce yes;
          INTEL_IOMMU_DEFAULT_ON = lib.mkForce yes;
          SLS = lib.mkForce yes;
          INTEL_IOMMU_SVM = lib.mkForce yes;
          BINFMT_MISC = lib.mkForce no;
          KEXEC = lib.mkForce no;
          HIBERNATION = lib.mkForce no;
          COMPAT = lib.mkForce no;
          IA32_EMULATION = lib.mkForce no;
          X86_MSR = lib.mkForce no;
        };
      }
    ];
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
