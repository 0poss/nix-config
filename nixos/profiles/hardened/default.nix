{ pkgs, lib, ... }:
let
  # TODO : make it easily available in the flake.
  mkHardOpt = lib.mkOverride 99;
in
{
  boot = {

    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_5_hardened.override
      {
        #stdenv = pkgs.ccacheStdenv;
        autoModules = true;
        ignoreConfigErrors = true;
      });

    kernelPatches = [
      {
        name = "oposs-hardening";
        patch = null;
        extraStructuredConfig =
          let
            hye = mkHardOpt lib.kernel.yes;
            hno = mkHardOpt lib.kernel.no;
          in
          {
            EXPERT = hye;

            TRIM_UNUSED_KSYMS = hye;
            XFS_FS = hno;
            AIO = lib.mkOverride 99 lib.kernel.no;
            INPUT_EVBUG = hno;
            FTRACE = hno;
            KPROBES = hno;
            EFI_CUSTOM_SSDT_OVERLAYS = hno;
            #FB = hno;
            STAGING = hno;
            COREDUMP = hno;

            AF_KCM = hno; # necessary to disable BPF_SYSCALL
            BPF_SYSCALL = hno;

            DLM = hno; # necessary to disable SCTP
            IP_SCTP = hno;
            IP_DCCP = hno;

            ACPI_TABLE_UPGRADE = hno;
            X86_IOPL_IOPERM = hno;
            X86_CPUID = hno;
            USER_NS = hno;
            KEXEC_CORE = hno;
            KEXEC = hno;
            KEXEC_FILE = hno;
            MAGIC_SYSRQ = hno;
            KALLSYMS = hno;
            KSM = hno;
            HIBERNATION = hno;
          };
      }
    ];

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
      "kernel.printk" = mkHardOpt "3 3 3 3";
      "kernel.kptr_restrict" = mkHardOpt 2;
      "kernel.ftrace_enabled" = mkHardOpt false;
      "kernel.core.bpf_jit_enable" = mkHardOpt true;
      "dev.tty.ldisc_autoload" = mkHardOpt 0;
      "net.ipv4.tcp_rfc1337" = mkHardOpt 1;
      "net.ipv4.icmp_echo_ignore_all" = mkHardOpt 1;
      "net.ipv6.icmp_echo_ignore_all" = mkHardOpt 1;
      "net.ipv4.tcp_sack" = mkHardOpt 0;
      "net.ipv4.tcp_dsack" = mkHardOpt 0;
      "net.ipv4.tcp_fack" = mkHardOpt 0;
      "kernel.yama.ptrace_scope" = mkHardOpt 2;
    };
  };

  systemd.coredump.enable = false;

  security = {
    apparmor = {
      enable = mkHardOpt true;
      killUnconfinedConfinables = mkHardOpt true;
    };

    lockKernelModules = mkHardOpt true;
    protectKernelImage = mkHardOpt true;
    forcePageTableIsolation = mkHardOpt true;
    virtualisation.flushL1DataCache = mkHardOpt "always";
  };
}
