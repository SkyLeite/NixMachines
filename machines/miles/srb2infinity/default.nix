{ config, pkgs, lib, srb2pkgs, ... }:
let filesPath = ./files;
in {
  imports = [ ../../../modules/chaos-service.nix ../../../modules/srb2.nix ];

  services.srb2 = {
    enable = true;
    package = srb2pkgs.srb2;
    port = 6767;
    config = {
      files = lib.filesystem.listFilesRecursive filesPath;
      clientConfig = ''
        servername "[zap] SRB2Infinity"
        execversion "52"
        flipcam2 "No"
        flipcam "No"
        homremoval "No"
        addons_folder ""
        addons_option "Default"
        allowseenames "Yes"
        showping "Warning"
        pingtimeout "10"
        maxping "0"
        cpusleep "1"
        skipmapcheck "Off"
        jointimeout "350"
        nettimeout "350"
        blamecfail "Off"
        showjoinaddress "Off"
        joinnextround "Off"
        allowjoin "On"
        downloading "On"
        downloadspeed "16"
        noticedownload "Off"
        maxsend "4096"
        resynchattempts "10"
        rejointimeout "2"
        joindelay "10"
        maxplayers "8"
        respawndelay "3"
        allowteamchange "Yes"
        restrictskinchange "Yes"
        allowexitlevel "No"
        pausepermission "Server"
        overtime "Yes"
        countdowntime "60"
        startinglives "3"
        tv_eggman "5"
        tv_1up "5"
        tv_bombshield "5"
        tv_forceshield "5"
        tv_ringshield "5"
        tv_watershield "5"
        tv_jumpshield "5"
        tv_invincibility "5"
        tv_supersneaker "5"
        tv_superring "5"
        tv_teleporter "5"
        tv_recycler "5"
        matchboxes "Normal"
        competitionboxes "Mystery"
        powerstones "On"
        specialrings "On"
        cooplives "Avoid Game Over"
        coopstarposts "Per-player"
        timelimit "None"
        exitmove "On"
        playersforexit "All"
        advancemap "Next"
        inttime "10"
        hidetime "30"
        touchtag "Off"
        scrambleonchange "Off"
        teamscramble "Off"
        autobalance "Off"
        basenumlaps "Map default"
        pointlimit "None"
        friendlyfire "Off"
        flagtime "30"
        respawnitem "On"
        respawnitemtime "30"
        masterserver_token ""
        masterserver_debug "Off"
        masterserver_timeout "5"
        masterserver_update_rate "15"
        masterserver "https://mb.srb2.org/MS/0"
        gr_filtermode "Nearest"
        gr_shaders "On"
        gr_shearing "Off"
        gr_fakecontrast "Smooth"
        gr_spritebillboarding "Off"
        gr_skydome "On"
        gr_models "Off"
        gr_modelinterpolation "Sometimes"
        gr_modellighting "Off"
        gr_fovchange "Off"
      '';
    };
  };

  chaos.services.srb2infinity = {
    enable = true;
    port = 6767;
    caddyOptions = ''
      root * ${filesPath}
      file_server browse
    '';
  };
}
