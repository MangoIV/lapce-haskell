{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  postgresql,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "lapce-volts";
  version = "unstable-2023-01-14";

  src = fetchFromGitHub {
    owner = "lapce";
    repo = "lapce-volts";
    rev = "fa153d3739a77b13b034bcefe42d7fd0b1988333";
    hash = "sha256-9lK95mlflndc+KjRtqRyIw7TbeOLYTViVqwzOvERCrg=";
  };

  cargoHash = "sha256-fRdFcuJn+WEvjWWdxhYogQKDeBalWR0GhVMK+TNwPXc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      postgresql
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/lapce/lapce-volts";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "lapce-volts";
  };
}
