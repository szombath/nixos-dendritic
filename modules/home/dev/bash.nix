{
  flake.modules.homeManager.bash =
{ config, lib, pkgs, ... }: 
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    bashrcExtra = ''
      # goes verbatim into ~/.bashrc
      export EDITOR=vi
      export VISUAL=vi
    '';

    initExtra = ''     
      # runs when an interactive shell starts
      # Load __git_ps1 bash command.
      . ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
      # Also load git command completions for bash.
      . ~/.nix-profile/share/git/contrib/completion/git-completion.bash
      # Show git branch status in terminal shell.
      export PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]]$(__git_ps1 " (%s)")\[\033[00m\]\$ '

      ################################################################################
      # some handy (alias) functions
      ################################################################################

      # function which adds an alias to the current shell and to ~/.bash_aliases file.
      function add-alias() {
         local name=$1 value="$2";
         echo alias $name=\'$value\' >>~/.bash_aliases;
         eval alias $name=\'$value\';
         alias $name;
      }
 
      # "repeat" command.  Like: repeat 10 echo foo
      function repeat() {
          local count="$1" i;
          shift;
          for i in $(seq 1 "$count");
          do
              eval "$@";
          done;
      }
       
      # Subfunction needed by `repeat'.
      function seq() {
          local lower upper output;
          lower=$1 upper=$2;
          while [ $lower -le $upper ];
          do
              output="$output $lower";
              lower=$[ $lower + 1 ];
          done;
          echo $output;
      }
      
      # This is a little like `zap' from Kernighan and Pike
      function pskill() {
          local pid;
          pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }');
          echo -n "killing $1 (process $pid)...";
          kill -9 $pid;
          echo "slaughtered.";
      }
      
      # psg - ps + grep
      function psg() { /usr/bin/ps -aef | grep -i $1 | grep -v grep; }
      
      # mcd - mkdir + cd
      function mcd() { mkdir -p $1 && cd $1; }
     
      # fmrf - find most recent file
      fmrf () {
          FILE=$(ls -Art1 ''${CURRENT_DIR} | tail -n 1)
          if [ ! -f ''${FILE} ]; then
              CURRENT_DIR="''${CURRENT_DIR}/''${FILE}"
              get_recent_file
          fi
          echo $FILE
          exit
      }

      # Print N most recently modified files in current dir or below
      mrf() {
          local _n=''${1:-3} # Default to 3
          find . -type f -exec stat -c '%X %n' {} \; | sort -nr | awk -v var="''${_n}" 'NR==1,NR==var {print $0}' | while read t f; do d=$(date -d @$t "+%b %d %T %Y"); echo "$d -- $f"; done
      }


      cdl () { cd "$(dirname "$(readlink "$1")")"; }
    '';

    profileExtra = ''
      # goes into ~/.bash_profile (login shells only)
      shopt -s histappend   # Append to history file instead of overwriting it
                            # Prevents losing history when multiple terminals are open
      shopt -s checkwinsize # Update LINES and COLUMNS variables after each command
                            # Fixes display issues when terminal is resized
      shopt -s globstar     # Enable ** recursive globbing (bash 4.0+)
                            # Allows: ls **/*.txt (find all .txt files recursively)
    ''; 
    
    sessionVariables = {
      # ===== CUSTOM COLORED PROMPT =====
      # Format: user@hostname:/current/path$ 
      # Colors: green for user@host, blue for path, reset to normal for $
      PS1="[\[\033[01;32m\]\u@\h\[\033[00m\]:\['\033[01;34m\]\w\[\033[00m\]\$ ]";
      # \[\033[01;32m\] = bright green
      # \u = username
      # @ = literal @
      # \h = hostname
      # \[\033[00m\] = reset color
      # : = literal colon
      # \[\033[01;34m\] = bright blue  
      # \w = current working directory
      # \$ = $ for regular user, # for root
      
      # ===== COMPILER OUTPUT COLORS =====
      # Make GCC/G++ error messages colorized for easier reading
      GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01";
      # error=01;31    = bright red for errors
      # warning=01;35  = bright magenta for warnings  
      # note=01;36     = bright cyan for informational notes
      # caret=01;32    = bright green for error location carets (^)
      # locus=01       = bright white for file:line:column locations
      # quote=01       = bright white for quoted code sections
    };
    
    historySize = 5000;       # Keep 5000 commands in memory during session
    historyFileSize = 100000; # Keep 500000 commands in ~/.bash_history file  
    # Control what gets saved to history
    historyControl = [ "ignoreboth" ];
    # ignoreboth = ignorespace + ignoredups
    # ignorespace: don't save commands starting with space (for sensitive commands)
    # ignoredups: don't save duplicate consecutive commands
  
    # Based on https://wiki.archlinux.org/title/Fish#Setting_fish_as_interactive_shell_only
    # It is much safer to use Fish as an interactive shell instead of the default shell
    # This starts a bash shell and then execs into a Fish shell
    #initExtra = ''
    #  if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    #  then
    #    shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
    #    exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    #  fi
    #'';
  };

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


