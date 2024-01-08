{ pkgs, lib, ... }:
let
  dataDir = "/var/lib/mautrix-telegram";
  configFile = "${dataDir}/config.yaml";
  registrationFile = "${dataDir}/telegram-registration.yaml";
  mautrix-telegram-bridge-wrapped = pkgs.writeShellScript "mautrix-telegram-bridge-wrapped" ''
    if [ ! -f ${configFile} ]; then
      ${pkgs.mautrix-telegram}/bin/mautrix-telegram \
        --generate-registration \
        --config=${configFile} \
        --registration=${registrationFile}
    fi; exec ${pkgs.mautrix-telegram}/bin/mautrix-telegram \
        --config=${configFile} --ignore-foreign-tables
  '';
in {
  users.users.mautrix-telegram = {
    isSystemUser = true;
    home = dataDir;
    homeMode = "755";
    createHome = true;
    group = "mautrix-telegram";
  };
  users.groups.mautrix-telegram = {};

  systemd.packages = [ pkgs.mautrix-telegram ];
  environment.systemPackages = [ pkgs.mautrix-telegram ];
  systemd.services.mautrix-telegram = {
    description = "the matrix-telegram bridging service.";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ lottieconverter ]; # no ffmpeg?
    serviceConfig = {
      WorkingDirectory = dataDir;
      ExecStart = mautrix-telegram-bridge-wrapped;
      User = "mautrix-telegram";
    };
  };
  services.matrix-synapse.settings.app_service_config_files = [ registrationFile ];
}
