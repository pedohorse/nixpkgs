{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, libadwaita
, distrobox
}:

rustPlatform.buildRustPackage rec {
  pname = "boxbuddy";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "Dvlv";
    repo = "BoxBuddyRS";
    rev = version;
    hash = "sha256-b7b5IWo2REr0HBfsKbnFYcReEQG5SfuGDa9KSKIC3t0=";
  };

  cargoHash = "sha256-h+pDjS+VtvfiaWMQjpFHBBJ/8bZ0SRgayRmx4vg96Jw=";

  # The software assumes it is installed either in flatpak or in the home directory
  # so the xdg data path needs to be patched here
  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace-fail '{data_home}/locale' "$out/share/locale" \
      --replace-fail '{data_home}/icons/boxbuddy/{}' "$out/share/icons/boxbuddy/{}"
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  postInstall = ''
    cp icons/* ./
    XDG_DATA_HOME=$out/share INSTALL_DIR=$out ./scripts/install.sh
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ distrobox ]}
    )
  '';

  doCheck = false; # No checks defined

  meta = with lib; {
    description = "An unofficial GUI for managing your Distroboxes, written with GTK4 + Libadwaita";
    homepage = "https://dvlv.github.io/BoxBuddyRS";
    license = licenses.mit;
    mainProgram = "boxbuddy-rs";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
