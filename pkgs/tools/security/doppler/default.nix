{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.24.1";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-ZWYyi/Fv18dA8MeKzcFHHm62RF1NfPyveWIE8aI4UxU=";
  };

  vendorSha256 = "sha256-UaR/xYGMI+C9aID85aPSfVzmTWXj4KcjfOJ6TTJ8KoY=";

  buildFlagsArray = "-ldflags=-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}";

  postInstall = ''
    mv $out/bin/cli $out/bin/doppler
  '';

  meta = with lib; {
    homepage = "https://doppler.com";
    description = "The official CLI for interacting with your Doppler Enclave secrets and configuation";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
