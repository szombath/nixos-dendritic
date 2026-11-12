{ config, pkgs, ... }:
{
  programs.bash = {
    # System-wide aliases available to all users
    shellAliases = {
      # Enhanced ls commands
      ll = "ls -alF";  # Long format + all files + classify file types (/ for dirs, * for executables)
      la = "ls -A";    # List all files except . and .. (includes hidden files)
      lc = "ls -CF";   # Column format + classify file types

      # Single character shortcuts
      h="history";
      j="jobs -l";
      m="less";
      b="cd -";
      l="locate";
      f="find";
      g="grep";

      # Extra shortcuts
      gr="grep -r";
      hg="history | grep";
      hgg="history | grep grep";

      mr="less -r";

      mv="mv -v";
      cp="cp -v";
      ex="exit $*";
      ps="ps $* -aef";
      pu="pushd";
      po="popd";
      md="mkdir";
      rd="rmdir";
      ff="find -name";
      
      which="type -path";
      cls="reset";

      chmx="chmod a+x";
      chme="chown szombath:szombath";

      cdd="cd ~/Downloads";

      # Nix shortcuts
      nxcd="cd ~/etc/nixos";
      nxrb="cd ~/etc/nixos; sudo nixos-rebuild switch --flake .#aimax";
      nxfu="cd ~/etc/nixos; nix flake update";
      nxwh="sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d";
      nxgc="sudo nix-collect-garbage --delete-old";

      nho="nh os";
      nhosw="nho switch";
      nhob="nho build";
      nhot="nho test";
      nhoi="nho info";

      nhh="nh home";
      nhhb="nhh build";
      nhht="nhh test";

      nhs="nh search";
      nhcl="nh clean";

      # Git aliases
      gia="git add";

      gib="git branch";
      giba="git branch -a";
      gibmv="git branch -m";
      gibrm="git branch -D";

      gibrmr="git remote update origin --prune";

      gick="git checkout";
      gickb="git checkout -b";
      gichp="git cherry-pick";

      gicl="git clone";
      giclr="git clone --recursive";

      gic="git commit";
      gicm="git commit -m";
      gicam="git commit -am";
      gicame="git commit --allow-empty -am";
      gica="git commit --amend";
      gicah="git commit --amend .";

      gid="git diff -b --ignore-cr-at-eol";
      gidh="git diff -b --ignore-cr-at-eol HEAD";
      gidh1="git diff -b --ignore-cr-at-eol HEAD~";
      gidn="git diff --name-only";

      gifa="git fetch --all";

      gih="git help";

      gil="git log | head -n 10";
      gilm="git log --color=always | less -r";
      gilo="git log --oneline | head -n 25";
      gilom="git log --oneline --color=always | less -r";

      gip="git pull";
      gipu="git push";
      gipuf="git push --force-with-lease";
      gipurm="git push origin --delete";

      girb="git rebase";
      girbi="git rebase -i";
      girbif="git rebase -i HEAD~~~~~"; # five
      girbit="git rebase -i HEAD~~~~~~~~~~"; # ten
      girbi20="git rebase -i HEAD~~~~~~~~~~~~~~~~~~~~"; # twenty
      girbi40="git rebase -i HEAD~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; # forty
      girba="git rebase --abort";
      girbc="git rebase --continue";

      girs="git reset --soft";
      girs1="git reset --soft HEAD~";
      girsh="git reset --hard";
      girsh1="git reset --hard HEAD~";

      gis="git status";
      gisl="gis; echo; gilo";

      gismu="git submodule update";

      gias="gia src; clf; gis";
      giat="gia test; clf; gis";
      
      # Power managment
      sxx="sudo systemctl sleep";
      sxs="sudo systemctl suspend";
      sxh="sudo systemctl hibernate";
      sxhs="sudo systemctl hybrid-sleep";
      sxsth="sudo systemctl suspend-then-hibernate";
      srb="sudo reboot";
      spo="sudo poweroff";

      # Text editor
      ed="gedit";
      #edn="gedit --new-window";
      vsc="vscodium";

      sup="sudo updatedb";
      sud="sudo dmesg --human";
      suv="sudo -E nvim";

      #######################################################
      # edit/refresh/show aliases itself
      #######################################################

      real=". ~/.bash_aliases && alias";
      edal="gedit --new-window ~/.bash_aliases && real";
      vial="vi ~/.bash_aliases && real";

      #######################################################

      # Network utility - get your public IP address
      publicip = "dig +short myip.opendns.com @resolver1.opendns.com";
      # Uses DNS query to OpenDNS to get external IP (faster than curl to web services)
      
      # System maintenance commands
      sysupdate = "sudo nix-collect-garbage && sudo nixos-rebuild switch --upgrade";
      # Rebuild NixOS system and clean up unreferenced packgs to save disk space
      sysupdatewipe = "sudo nix-collect-garbage -d && sudo nixos-rebuild switch --upgrade && systemctl reboot"; 
      
      # TTS 
      say = "spd-say";

      # Desktop notification for long-running commands
      alert = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e 's/^[[:space:]]*[0-9]\\+[[:space:]]*//;s/[;&|]\\s*alert$//')\"";
      # Usage: long-command; alert
      # Shows desktop notification with success/failure icon and the command that just ran
    };
  }; # end of bash configuration
}
