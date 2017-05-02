# success = green
# warning or err = red
# help or neutral things = cyan
NC='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'

slash="/"
deps="dependencies"

#map functions so we can support bash 3
hinit() {
    rm -f /tmp/hashmap.$1
}

hput() {
    echo "$2 $3" >> /tmp/hashmap.$1
}

hget() {
    grep "^$2 " /tmp/hashmap.$1 | awk '{ print $2 };'
}



function library {
	if [[ "$1" == "save" ]]; then
		printf "$2\n" > /usr/local/lib/ospmLibSettings
	elif [[ "$1" == "clean" ]]; then
		cat /usr/local/lib/ospmLibSettings
	else
		printf "${YELLOW}Module library is:\n${NC}"
		output=$(cat /usr/local/lib/ospmLibSettings)
		printf "${YELLOW}$output\n${NC}"
	fi

}

function help {
	printf "${YELLOW}Usage: ospm [-v] [-h] [library <> <>]\n${NC}"
	printf "${YELLOW}-v                Show version\n${NC}"
	printf "${YELLOW}-h                Show command line options\n${NC}"
	printf "${YELLOW}library $2 $3         Save XXX in library\n${NC}"
}

function uninstall {
	libLoc=$(cat /usr/local/lib/ospmLibSettings)
	packageDir="$1-$2-$3"
	#some safety
	if [ ! -z $libLoc ] && [ "$libLoc" != "/" ] && [ ! -z $1 ] && [ ! -z $2 ] && [ ! -z $3 ]; then
		#for each package check if the target package is a requirement
		#if so it is an easy stop (show all for ease) with little processing.

		beingUsed=false
		echo "dollar four is $4"
		if [[ $4 != "force" ]]; then
			for d in $( ls -d $libLoc$slash*/ ) ; do #this wont work :(
				if grep -Fxq "$1 $2 $3" $d$deps
				then
					echo "$1 $2 $3 is being used in $d"
					beingUsed=true
				fi
			done
		fi

		if [[ $beingUsed = true ]]; then
			echo -n "Proceed with uninstall (y/n)? "
				read answer
				if echo "$answer" | grep -iq "^y" ; then
				    rm -rf $libLoc$slash$packageDir
				else
				    echo "Ok, won't uninstall then."
				fi
		fi

		rm -rf $libLoc$slash$packageDir

	fi
}

function install {
	libLoc=$(cat /usr/local/lib/ospmLibSettings)
	#install from list
	if [[ ! -z $libLoc ]]; then
		if [[ "$1" == "list" ]]; then
			if [ -f "$2" ]; then
				while read -r dep; do
					printf "${YELLOW}$dep\n${NC}"
					dep_dir=$libLoc$slash$dep
					if [ ! -z "$dep" ] && [ "$dep" != "\n" ]; then
						source ospm.sh install $dep
					fi
				done <$2
			fi
		else
			slash=$(echo /)
			deps=$(echo dependencies)
			underscore_ospm=$(echo "_ospm")
			saveLoc=$libLoc$slash$1-$2-$3
			echo $saveLoc
			if [ ! -d "$saveLoc" ]; then
				git clone -b $3  --single-branch --depth 1 https://github.com/$1/$2 $saveLoc
				# git clone https://github.com/$1/$2.git $saveLoc
			else
				printf "${GREEN}$1-$2-$3 already installed$\n${NC}"
			fi

				#required by file
				requiredBy="requiredBy"
				requiredByFile=$saveLoc$slash$requiredBy
				if [ ! -z "$4" ] && [ ! -z "$5" ] && [ ! -z "$6" ] && ( ! grep -Fxq "$saveLoc$slash$4-$5-$6" $requiredByFile ); then
					 echo "$4 $5 $6" >> $requiredByFile
				fi

				if [ -f "$saveLoc$slash$deps" ]; then
					while read -r dep; do
						printf "${YELLOW}$dep\n${NC}"
						dep_dir=$libLoc$slash$dep
						if [ ! -z "$dep" ] && [ "$dep" != "\n" ]; then
							depArr=($dep)
							source ospm.sh install ${dep[0]} ${dep[1]} ${dep[2]} $1 $2 $3
						fi
					done <$saveLoc$slash$deps
				fi
		fi


	else
		printf "${YELLOW}Save the location of your installation library with: \n${NC}"
		printf "${YELLOW}ospm library <location>\n${NC}"
		printf "${YELLOW}ospm help has more information\n${NC}"
	fi
}

case "$1" in
	"library" )
	library $2 $3
	;;
	"install" )
	install $2 $3 $4 $5 $6 $7
	;;
	"uninstall" )
	uninstall $2 $3 $4 $5
	;;
	"-v" )
	printf "${YELLOW}ospm 0.0.1\n${NC}"
	;;

	"-h" )
	help
	;;
	*)
	printf "${RED}command not found\n${NC}";
esac
