prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

#Colors
reset=$(tput sgr0);
bold=$(tput bold);
black=$(tput setaf 0);
white=$(tput setaf 15);
grey=$(tput setaf 248);
blue=$(tput setaf 33);
green=$(tput setaf 64);
red=$(tput setaf 124);
yellow=$(tput setaf 228);
violet=$(tput setaf 55);
orange=$(tput setaf 166);
cyan=$(tput setaf 80);

#PS1
PS1="\[${cyan}\]\u";   #username
PS1+="\[${white}\]\[${bold}\]@\[${reset}\]";
PS1+="\[${orange}\]\h";  #hostname
PS1+="\[${white}\]\[${bold}\] in \[${reset}\]";
PS1+="\[${green}\]\[${bold}\][\[${reset}\]";
PS1+="\[${grey}\]\W";  #directory
PS1+="\[${reset}\]\[${green}\]\[${bold}\]]";
PS1+="\$(prompt_git \"\[${yellow}\] on \" \"\[${blue}\]\")"; #Git repository
PS1+="\[${reset}\]\n$";

#personal alias
alias la='ls -la';
alias ll='ls -l';
alias ..='cd ..';
alias ...='cd ../..';
alias home='cd ~';
alias disk='cd /';
alias doc='cd ~/Documents';
alias dow='cd ~/Downloads';
alias desk='cd ~/Desktop';

#alias for Windows -> Debian console on Windows 10
alias whome='cd /mnt/c/Users/ednoe/'
alias wdisk='cd /mnt/c/'
alias wdoc='cd /mnt/c/Users/ednoe/Documents'
alias wdow='cd /mnt/c/Users/ednoe/Downloads'
alias wdesk='cd /mnt/c/Users/ednoe/Desktop'

#git alias
alias add='git add';
alias com='git commit -m';
alias push='git push';
alias st='git status';
