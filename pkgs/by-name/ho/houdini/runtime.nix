{ requireFile, callPackage }:

callPackage ./runtime-build.nix rec {
  version = "20.5.410";
  eulaDate = "2021-10-13";
  src = requireFile {
    name = "houdini-${version}-linux_x86_64_gcc11.2.tar.gz";
    hash = "sha256-8hvZFtLakSB15q7DKP9ZHvW53uEqIfBGxbiE2RItxDU=";
    url = "https://www.sidefx.com/download/daily-builds/?production=true";
  };
  outputHash = "sha256-pS8LB7054WOHu0SPXjGbiz3ONXve2s+bwLmcBAdF/+c=";
}
