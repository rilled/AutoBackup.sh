# AutoBackup.sh #
# by ejuliao- && tpereira #
# forked by rilled
BASEDIR="${HOME}/.auto-backup/"
BACKUPS="${HOME}${BASEDIR}locations.yml"
BACKUP_LOCATION="${BASEDIR}"

menu() {
	typeCheck
	while :
  do
    clear
    cat<<EOF
    ==============================
    Backups Menu
    ------------------------------
    Please enter your choice:

    (1) Add backup path
    (2) Remove backup path
		(3) Set backup location
    (Q)uit
    ------------------------------
EOF
    read REPLY
    case "${REPLY}" in
    "1")  addLocation ;;
    "2")  removeLocation ;;
		"3")  setBackupLocation ;;
    "Q" | "q")  exit ;;
     * )  echo "invalid option" ;;
    esac
    sleep 1
  done
}

typeCheck() {
  checkFile && checkFolder
  if [ "$*" == "" ]; then
    doBackup
  elif [ "$1" == "h" | "-h" | "help" | "-help" ]; then
    help # todo, help
  fi
}

checkFolder() {
  if [ ! -d ${BASEDIR} ]; then
    mkdir -p ${BASEDIR}
  fi
}

checkFile() {
  if [ ! -f ${BACKUPS} ]; then
    touch ${BACKUPS}
  fi
}

setBackupLocation() {
	while :
  do
    clear
    cat<<EOF
    ==============================
    Backups Directory
    ------------------------------
    Please set the backup location.

    (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "${REPLY}" in
    "Q" | "q")  exit ;;
     * )
      ${BACKUP_LOCATION}=${REPLY}
      echo "Backups will now save to '${BACKUP_LOCATION}'" ;;
    esac
    sleep 1
  done
}

addLocation() {
  while :
  do
    clear
    cat<<EOF
    ==============================
    DriveSpace Menu [Add Location]
    ------------------------------
    Please enter a valid location.

    (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "${REPLY}" in
    "Q" | "q")  exit ;;
     * )
      ${REPLY} >> ${BACKUPS}
      echo "Location '${REPLY}' added." ;;
    esac
    sleep 1
  done
}

removeLocation() {
  while :
  do
    clear
    cat<<EOF
    ==============================
    DriveSpace Menu [Remove Location]
    ------------------------------
    Please enter a valid location.

    (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "${REPLY}" in
    "Q" | "q")  exit ;;
     * )
     if grep -Fxq ${BACKUPS} ${REPLY}
     then
       sed -e "s/${REPLY}//g" -i ${BACKUPS}
       echo "Location '${REPLY}' removed."
     else
       echo "Location not found in folder."
     fi ;;
    esac
    sleep 1
  done
}

doBackup() {
	export BACKUP_META="$(date +'%Y-%m-%d__%H-%M-%S')"
	clear && cd ${BACKUP_LOCATION}
	mkdir -p ${BACKUP_META} && cd ${BACKUP_META}
	echo "starting backup!"

	while IFS='' read -r LINE || [ -n "${LINE}" ]; do
		tar -czvf "${LINE}_${BACKUP_META}" ${LINE}
	done < ${BACKUPS}
	unset BACKUP_META
	exit
}
