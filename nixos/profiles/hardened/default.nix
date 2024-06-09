{ pkgs, lib, ... }:
let
  # TODO : make it easily available in the flake.
  mkHardOpt = lib.mkOverride 99;
in
{
  # The build sandbox - with this hardened profile at least - makes the check
  # fail, so disable it.
  services.logrotate.checkConfig = false;

  boot = {
    kernelPackages = pkgs.linuxPackagesFor (
      (pkgs.linux_6_9_hardened.override {
        #stdenv = pkgs.ccacheStdenv;
        autoModules = true;
        ignoreConfigErrors = true;
      }).overrideAttrs
        (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.ncurses ];
        })
    );

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
            WERROR = hye;

            TRIM_UNUSED_KSYMS = hye;
            XFS_FS = hno;
            AIO = hno;
            INPUT_EVBUG = hno;
            FTRACE = hno;
            KPROBES = hno;
            EFI_CUSTOM_SSDT_OVERLAYS = hno;
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
            INIT_ON_ALLOC_DEFAULT_ON = hye;
            INIT_ON_FREE_DEFAULT_ON = hye;
            RANDSTRUCT_FULL = hye;
            RANDSTRUCT_PERFORMANCE = hno;
            BLK_DEV_FD = hno;
            #FB = hno; # TODO the initrd doesn't like it
            SUNRPC_DEBUG = hno;
            PROVIDE_OHCI1394_DMA_INIT = hno;
            RSEQ = hno;
            # CONFIG_KCMP Selected by :
            # DRM [=y] && HAS_IOMEM [=y] && (AGP [=y] || AGP [=y]=n) && !EMULATED_CMPXCHG && HAS_DMA [=y]
            KCMP = hno;
            IO_URING = hno;
            BLK_DEV_UBLK = hno;
            HWPOISON_INJECT = hno;
            MTD_PHRAM = hno;
            MTD_SLRAM = hno;
            DEBUG_VIRTUAL = hye;
            UBSAN = hye;
            UBSAN_ENUM = hye;
            UBSAN_BOUNDS = hye;
            UBSAN_LOCAL_BOUNDS = hye;
            UBSAN_TRAP = hye;
            UBSAN_SANITIZE_ALL = hye;
            RESET_ATTACK_MITIGATION = hye;
            SLS = hye;
            IA32_EMULATION = hno;
            COMPAT = hno;
            DEBUG_FS = hno;
            MEMTEST = hno;

            PUNIT_ATOM_DEBUG = hno;
            X86_DEBUG_FPU = hno;
            DEBUG_ENTRY = hno;
            IO_DELAY_NONE = hye;
            IO_DELAY_0X80 = hno;
            EARLY_PRINTK = hno;
            X86_VERBOSE_BOOTUP = hno;
            RCU_TRACE = hno;
            RCU_REF_SCALE_TEST = hno;
            DEBUG_PLIST = hno;
            SCF_TORTURE_TEST = hno;
            SCHEDSTATS = hno;
            TEST_LOCKUP = hno;
            TEST_UBSAN = hno;
            UBSAN_SHIFT = hye;
            UBSAN_DIV_ZERO = hye;
            STRIP_ASM_SYMS = hye;
            DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = hno;
            DEBUG_INFO_NONE = hye;
            DEBUG_BUGVERBOSE = hno;
            EFI_DISABLE_PCI_DMA = hye;
            USERFAULTFD = hno;
            CROSS_MEMORY_ATTACH = hno;
            BOOTPARAM_HARDLOCKUP_PANIC = hye;
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

  environment.memoryAllocator.provider = mkHardOpt "graphene-hardened";

  systemd.coredump.enable = mkHardOpt false;

  security = {
    apparmor = {
      enable = mkHardOpt true;
      killUnconfinedConfinables = mkHardOpt true;
    };

    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          # TODO : instead of using `groups=["wheel"]`, enumerate all users
          # which are in the wheel group and add them to the `users` list.
          # It shouldn't change anything for normal use cases.
          groups = [ "wheel" ];
          persist = true;
        }
      ];
    };

    lockKernelModules = mkHardOpt true;
    protectKernelImage = mkHardOpt true;
    forcePageTableIsolation = mkHardOpt true;
    virtualisation.flushL1DataCache = mkHardOpt "always";
  };

  #nixpkgs.overlays = [
  #  (final: prev: {
  #    ungoogled-chromium = prev.ungoogled-chromium.overrideAttrs (ucOld: {
  #      passthru = ucOld.passthru // {
  #        browser = ucOld.passthru.browser.overrideAttrs (bOld: {
  #          gnFlags = bOld.gnFlags + " is_asan=true";
  #        });
  #      };
  #    });
  #  })
  #];
}
