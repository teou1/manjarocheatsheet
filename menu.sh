#!/bin/bash
# Creator: Todor Uzunov a.k.a. Teo
# License: GNU - free like free speech and free beer for everybody!
# https://forum.manjaro.org/t/my-manjaro-cheatsheet-in-a-menu-form/145943
VERSION=15.11.2025
# Changelog from last version: cleanup version, removed gtk2, xdialog, rkhunter; added spotlight and links to topics

# check if dependencies are present and ask for installation
if ! [[ "$(which dialog)" =~ (dialog) ]] &>/dev/null; then
	echo "dialog dependency is not found, please install: sudo pacman -S dialog"
	exit 1
fi

OPTIONS=(
	1 " Mirror Sync status and branch" "pacman-mirrors"
	2 " Refresh the mirror list" "sudo pacman-mirrors -f" # sudo pacman-mirrors --country Germany --api --protocol https
	3 " Update all without AUR" "sudo pacman -Syu"
	4 " Download all updates for offline install later" "sudo pacman -Syuw"
	5 " Force refresh and fix AUR database in pamac" "pamac update --aur --force-refresh"
	6 " Run pacdiff with Meld to compare changed configs" "DIFFPROG=meld pacdiff -s" # pamac install meld
	7 " List foreign (AUR) packages" "pacman -Qm"
	8 " List orphaned packages" "pacman -Qdt"
	9 " Check for updates of AUR with YAY, do not update" "yay -Qua" # pamac install yay
	10 " Update only AUR packages with YAY" "yay -Sua" # pamac install yay
	11 " Pamac update AUR packages" "pamac update --aur"
	12 " Remove orphaned packages" "sudo pacman -Rsu \$(pacman -Qtdq)"
	13 " Clean YAY, Pacman and Pamac cache" "yay -Scc" # pamac install yay
	14 " Show journal errors from current boot" "journalctl -b -p3 --no-pager"
	15 " Show journal errors from previous boot" "journalctl -b -1 -p3 --no-pager"
	16 " Show systemd bootlog only" "journalctl -b -t systemd"
	17 " Show kernel log" "journalctl -k"
	18 " Check for coredumps" "coredumpctl"
	19 " Clear coredumps on disk" "sudo rm -f /var/lib/systemd/coredump/*" #normally runs biweekly automatically
	20 " Regenerate hashes for the boot files after update" "sudo /root/verifier.sh -update" # requires the extra script, see https://forum.manjaro.org/t/utility-script-my-take-on-a-verified-boot/164729
	21 " Spotlight background refresh" "systemctl start --user spotlight.service" # requires the extra script, see https://forum.manjaro.org/t/spotlight-wallpaper-changer-for-xfce/181665
	22 " Spotlight background info" "xfce4-terminal --hold -e \"journalctl -t spotlight --no-pager\"" # requires the extra script, see above or https://github.com/teou1/spotlight-xfce/
	23 " Trim the root of the SSD" "sudo fstrim -v /" #normally run weekly
	24 " S.M.A.R.T. status of the disk and write cycles" "sudo smartctl --all /dev/nvme0" # smartctl --scan
	25 " Run wavemonitor to check Wifi channel and strength" "wavemon" # pamac install wavemon
	26 " List wifi networks around with strength and channel" "nmcli dev wifi"
	27 " Gather system info with inxi (filtered)" "inxi -zv8"
	28 " Update database for locate" "sudo updatedb" #normally run weekly
	29 " Use MAPARE to check if missing default packages" "bash <(curl -s https://gitlab.com/cscs/mapare/-/raw/main/mapare) -IP"
	30 " Check for missing files from packages" "sudo pacman -Qk 2>/dev/null | grep -v ' 0 missing files' "
	31 " Which package owns an existing file (paste filepath)" "read fileowner; pacman -Qo \$fileowner"
	32 " Which (installed or not) package contains a file (paste filename, online check)" "read whogotit; sudo pacman -Fyx \$whogotit"
	33 " Which (installed) package contains a file or directory (paste filename or path, offline check)" "read whogotit; pacman -Qo \$whogotit"
	34 " Check Appimage and Github Apps for updates" "\$HOME/Applications/appimageupdater5.sh" # requires the extra script, see https://forum.manjaro.org/t/automate-update-checks-for-externally-downloaded-software-in-tar-gz-or-appimage/161008
	35 " Check for flatpak updates and update" "flatpak update"
	36 " Remove orphaned (unused) flatpak runtimes" "flatpak uninstall --unused"
	37 " Clean flatpak cache" "rm -rfv /var/tmp/flatpak-cache-*"
	38 " Clean tmp bash history files and Totem stream cache" "rm -f ~/.bash_history-*.tmp && rm -f ~/.cache/totem/stream-buffer/*"
	39 " Show hidden spaceeaters above 100M in HOME" "du -sh -t +100M ~/.cache/* ~/.config/* ~/.local/share/*"
	40 " Show journal size" "journalctl --disk-usage"
	41 " Cut journal to 2 weeks" "sudo journalctl --vacuum-time=2weeks" # that probably also sets it fixed on 2 weeks
	42 " Display the apps making most network traffic. Exit with q" "sudo nethogs" # pamac install nethogs
	43 " Netscanner. Exit with q" "sudo netscanner" # pamac install netscanner
	44 " Show all network connections of an app (paste name or pid)" "read nethog; ss -tuap | grep \$nethog"
	45 " Whois (paste ip address)" "read ipaddress; whois \$ipaddress"
	46 " List all processes, listening on a network port" "sudo netstat -tulpn"
	47 " A 10-20 sec. cpu benchmark using bc to calculate PI" "time echo \"scale=5000; 4*a(1)\" | bc -l > /dev/null" # pamac install bc
	48 " Read sensors every second, press CTRL-C to exit" "watch -e -n 1 sensors"
	49 " Stress the CPU, useful for thermal or throttling tests, press CTRL-C to exit" "stress -c 16"
	50 " Traffic statistic for the last days and current month (vnstat)" "vnstat -d --style 0 --limit 5 | grep -v estimated && vnstat -m --style 0 --limit 3 | grep -v estimated" # install vnstat and start daemon
	51 " Fuzzy search in systemd services. Exit with esc" "sudo sysz" # pamac build sysz
	52 " Temporary disable Ideapad battery conservation mode" "sudo conservation_mode.sh 0" # pamac build conservation_mode
)
# last unique tag number is 52

while true; do
CHOICE=$(dialog --clear \
		--no-shadow \
		--no-tags \
		--item-help \
		--keep-tite \
		--scrollbar \
		--ok-label "Run" \
		--cancel-label "Exit" \
                --backtitle "" \
                --title "A Manjaro cheatsheet by Teo, version $VERSION" \
		--menu "Press Enter to run a command from the list or close the window to cancel:" \
                79 125 0 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
[[ $CHOICE ]] || break
echo "${OPTIONS[$(($(($CHOICE*3))-1))]}"
eval "${OPTIONS[$(($(($CHOICE*3))-1))]}"
read -n 1 -s -r -p "Press any key to return to menu or q to exit." REPLY;
echo ""
echo ""
echo "================================================="
echo ""
if [[ $REPLY == "q" ]]; then break; fi
done
