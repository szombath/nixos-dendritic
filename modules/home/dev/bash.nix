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

  # aliases
  imports = [
    ./bash_aliases.nix
  ];
}
