{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3,
  bintools-unwrapped,
  file,
  ps,
  gef,
  gdb,
}:

let
  pythonPath =
    with python3.pkgs;
    makePythonPath [
      keystone-engine
      unicorn
      capstone
      pygments
      requests
      ropper
      rpyc
      debugpy
    ];
in
stdenv.mkDerivation rec {
  pname = "gef-extras";
  version = "2024.01";

  src = fetchFromGitHub {
    owner = "hugsy";
    repo = pname;
    rev = version;
    sha256 = "sha256-Gp4ILhvP9yjvhJt4kNRHHVxMvxeFdUYfze/EsF+e9pI=";
  };

  nativeBuildInputs = [
    gef
    makeWrapper
  ];

  installPhase = ''
    mkdir -vp $out/share/gef-extras
    cp -rv $src/* $out/share/gef-extras

    touch $out/gef.rc
    makeWrapper ${gdb}/bin/gdb $out/bin/gef-extras \
      --set GEF_RC $out/gef.rc \
      --add-flags "-q -x ${gef}/share/gef/gef.py" \
      --set NIX_PYTHONPATH ${pythonPath} \
      --prefix PATH : ${
        lib.makeBinPath [
          python3
          bintools-unwrapped # for readelf
          file
          ps
        ]
      }

    $out/bin/gef-extras -q -ex "pi gef.config['context.layout'] += ' syscall_args'" \
       -ex "pi gef.config['context.layout'] += ' libc_function_args'" \
       -ex "gef config gef.extra_plugins_dir '$out/share/gef-extras/scripts'" \
       -ex "gef config pcustom.struct_path '$out/share/gef-extras/structs'" \
       -ex "gef config syscall-args.path '$out/share/gef-extras/syscall-tables'" \
       -ex "gef config context.libc_args True" \
       -ex "gef config context.libc_args_path '$out/share/gef-extras/glibc-function-args'" \
       -ex "gef config gef.tempdir '/tmp/gef'" \
       -ex 'gef save' \
       -ex quit
  '';

  dontBuild = true;
}
