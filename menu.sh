#!/bin/bash
# Creator: Todor Uzunov a.k.a. Teo
# License: GNU - free like free speech and free beer for everybody!
# https://forum.manjaro.org/t/my-manjaro-cheatsheet-in-a-menu-form/145943
# For the referenced external scripts check my other topics in the manjaro forum.
VERSION=10.02.2026
# Changelog from last version: restructuring the script to remove numeric tags; fixed cleaning of alpm download folders; rearranged the order of some commands; added theme variable

# Check if dependencies are present and ask for installation if not
if ! [[ "$(which dialog)" =~ (dialog) ]] &>/dev/null; then
	echo "dialog dependency is not found, please install: sudo pacman -S dialog"
	exit 1
fi

# Set custom theme if there is one
export DIALOGRC=/home/$USER/.dialogrctheme

OPTIONS=(
"pacman-mirrors" "Mirror Sync status and branch"
"sudo pacman-mirrors -f" "Refresh the mirror list" # sudo pacman-mirrors --country Germany --api --protocol https
"sudo pacman -Syu" "Update all without AUR"
"sudo pacman -Syuw" "Download all updates for offline install later"
"pamac update --aur --force-refresh" "Force refresh and fix AUR database in pamac"
"DIFFPROG=meld pacdiff -s" "Run pacdiff with Meld to compare changed configs" # pamac install meld
"pacman -Qm" "List foreign (AUR) packages"
"pacman -Qdt" "List orphaned packages"
"yay -Qua" "Check for updates of AUR with YAY, do not update" # pamac install yay
"yay -Sua" "Update only AUR packages with YAY" # pamac install yay
"pamac update --aur" "Pamac update AUR packages"
"sudo pacman -Rsu \$(pacman -Qtdq)" "Remove orphaned packages"
"yay -Scc" "Clean YAY, Pacman and Pamac cache" # pamac install yay
"sudo rm /var/cache/pacman/pkg/download*/*; sudo rmdir /var/cache/pacman/pkg/download*" "Remove the temporary download cache folders from ALPM" # if yay -Scc errors out on download folders
"flatpak update" "Check for flatpak updates and update"
"flatpak uninstall --unused" "Remove orphaned (unused) flatpak runtimes"
"rm -rfv /var/tmp/flatpak-cache-*" "Clean flatpak cache"
"journalctl -b -p3 --no-pager" "Show journal errors from current boot"
"journalctl -b -1 -p3 --no-pager" "Show journal errors from previous boot"
"journalctl -b -t systemd" "Show systemd bootlog only"
"journalctl -k" "Show kernel log"
"coredumpctl" "Check for coredumps"
"sudo rm -f /var/lib/systemd/coredump/*" "Clear coredumps on disk" #normally runs biweekly automatically
"sudo /root/verifier.sh -update" "Regenerate hashes for the boot files after update" # requires the extra script, see https://forum.manjaro.org/t/utility-script-my-take-on-a-verified-boot/164729
"sudo updatedb" "Update database for locate" #normally run weekly automatically
"sudo fstrim -v /" "Trim the root of the SSD" #normally run weekly automatically
"sudo smartctl --all /dev/nvme0" "S.M.A.R.T. status of the disk and write cycles" # smartctl --scan
"inxi -zv8" "Gather system info with inxi (filtered)"
"wavemon" "Run wavemonitor to check Wifi channel and strength" # pamac install wavemon
"nmcli dev wifi" "List wifi networks around with strength and channel"
"bash <(curl -s https://gitlab.com/cscs/mapare/-/raw/main/mapare) -IP" "Use MAPARE to check if missing default packages"
"sudo pacman -Qk 2>/dev/null | grep -v ' 0 missing files' " "Check for missing files from packages"
"read fileowner; pacman -Qo \$fileowner" "Which package owns an existing file (paste filepath)"
"read whogotit; sudo pacman -Fyx \$whogotit" "Which (installed or not) package contains a file (paste filename, online check)"
"read whogotit; pacman -Qo \$whogotit" "Which (installed) package contains a file or directory (paste filename or path, offline check)"
"\$HOME/Applications/appimageupdater5.sh" "Check Appimage and Github Apps for updates" # requires the extra script, see https://forum.manjaro.org/t/automate-update-checks-for-externally-downloaded-software-in-tar-gz-or-appimage/161008
"rm -f ~/.bash_history-*.tmp" "Clean tmp bash history files"
"rm -f ~/.cache/totem/stream-buffer/*" "Clean Totem stream cache"
"du -sh -t +100M ~/.cache/* ~/.config/* ~/.local/share/*" "Show hidden spaceeaters above 100M in HOME"
"journalctl --disk-usage" "Show journal size"
"sudo journalctl --vacuum-time=2weeks" "Cut journal to 2 weeks" # that probably also sets it fixed on 2 weeks
"sudo nethogs" "Display the apps making most network traffic. Exit with q" # pamac install nethogs
"sudo netscanner" "Netscanner. Exit with q" # pamac install netscanner
"read nethog; ss -tuap | grep \$nethog" "Show all network connections of an app (paste name or pid)" 
"read ipaddress; whois \$ipaddress" "Whois (paste ip address)"
"sudo netstat -tulpn" "List all processes, listening on a network port"
"time echo \"scale=5000; 4*a(1)\" | bc -l > /dev/null" "A 10-20 sec. cpu benchmark using bc to calculate PI" # pamac install bc
"watch -e -n 1 sensors" "Read sensors every second, press CTRL-C to exit"
"stress -c 16" "Stress the CPU, useful for thermal or throttling tests, CTRL-C to exit"
"vnstat -d --style 0 --limit 5 | grep -v estimated && vnstat -m --style 0 --limit 3 | grep -v estimated" "Traffic statistic for the last days and current month (vnstat)" # install vnstat and start daemon
"sudo sysz" "Fuzzy search in systemd services. Exit with esc" # pamac build sysz
"systemctl start --user spotlight.service" "Spotlight background refresh" # requires the extra script, see https://forum.manjaro.org/t/spotlight-wallpaper-changer-for-xfce/181665
"xfce4-terminal --hold -e \"journalctl -t spotlight --no-pager\"" "Spotlight background info" # requires the extra script, see above or https://github.com/teou1/spotlight-xfce/
"sudo conservation_mode.sh 0" "Temporary disable Ideapad battery conservation mode" # pamac build conservation_mode
)

while true; do
CHOICE=$(dialog --clear \
		--no-shadow \
		--keep-tite \
		--scrollbar \
		--ok-label "Run" \
		--cancel-label "Exit" \
		--cursor-off-label \
                --backtitle "" \
                --title "A Manjaro cheatsheet by Teo, version $VERSION" \
		--menu "Press Enter to run a command from the list; hit Esc or close the window to exit:" \
                79 185 0 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
[[ $CHOICE ]] || break
echo "$CHOICE"
echo ""
eval "$CHOICE"
echo ""
read -n 1 -s -r -p "Press any key to return to menu or q to exit." REPLY;
echo ""
echo ""
echo "================================================="
echo ""
if [[ $REPLY == "q" ]]; then break; fi
done
