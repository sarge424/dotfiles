# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "onix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Graphics
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.opengl.enable = true;

  # Load NVIDIA drivers (works for Xorg and Wayland)
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Set up NVIDIA Optimus PRIME (manage iGPU and dGPU)
  # Using "sync" mode - dGPU is always on
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:6:0:0";

    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arjun = {
    isNormalUser = true;
    description = "arjun";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # Utils
  git                # Version management
  gh                 # GitHub
  vim                # Text editor
  fastfetch          # See system specs
  btop               # Task manager
  pciutils           # For lspci
  busybox            # tons of utils

  # GPU stuff
  mesa-demos
  vulkan-tools
  libGL
  mesa

  # Main apps
  ghostty            # Terminal
  firefox            # Browser
  vscode             # IDE
  pcmanfm            # File explorer
  signal-desktop

  # Development
  zig
  go
  cmake
  gnumake
  gcc

  # Audio
  pamixer            # Audio controls
  pavucontrol
  pulseaudio

  # Gaming
  heroic
  vulkan-tools
  wine
  winetricks
  ];

  # Enable automounting
  services.gvfs.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    xkb.layout = "us";
  };

  services.displayManager.sddm = {
    enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
