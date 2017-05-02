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

#depmap


#uninstallHelper
#recusively builds a map of required packages based on requirement graphs.
#params
# 1,2,3 are the auth, name, version of the package to check.
# 4 is the libaray path.
function otherRequirementMapBuilder {
	packageDir="$1-$2-$3"
	#pacakge not added to map, so add it.
	if [[ -z `hget otherDeps $packageDir` ]]; then
		libLoc=$4
		hput otherDeps $packageDir
		while read -r dep; do
			otherRequirementMapBuilder $dep $4
		done < $libLoc$slash$packageDir$slash$deps
	fi
	#package already added to map so doing nothing.
}

function targetRequirementMapBuilder {
	packageDir="$1-$2-$3"
	#pacakge not added to map, so add it.
	if [[ -z `hget targetDeps $packageDir` ]]; then
		libLoc=$4
		hput tagetDeps $packageDir
		while read -r dep; do
			targetRequirementMapBuilder $dep $4
		done < $libLoc$slash$packageDir$slash$deps
	fi
	#package already added to map so doing nothing.
}

function uninstall {
	echo "uninstall"
	hinit targetDeps
	hinit otherDeps
	libLoc=$(cat /usr/local/lib/ospmLibSettings)
	packageDir="$1-$2-$3"
	#some safety
	if [ ! -z $libLoc ] && [ "$libLoc" != "/" ] && [ ! -z $1 ] && [ ! -z $2 ] && [ ! -z $3 ]; then
		#for each package check if the target package is a requirement
		#if so it is an easy stop (show all for ease) with little processing.
		beingUsed=false
		for d in $( ls -d $libLoc$slash*/ ) ; do #this wont work :(
			if grep -Fxq "$1 $2 $3" $d$deps
			then
				echo "$1-$2-$3 is being used in $d"
				beingUsed=true
			fi
		done

		if [ $beingUsed ] ; then
			echo "Becuase $1-$2-$3 is being used, it cannot be uninstalled."
			return
		fi

		#from here we know that at least the target will be uninstalled.

		#build a map of all packages that are diretcly or indirectly required by
		#all packages besides the target package.

		for d in $( ls -d $libLoc$slash*/ ) ; do
			#check deps file to see if it is an ospm module.
			if [[ -f $d$slash$deps ]]; then
				#split on dashes
				auth=$(echo $d | cut -d'-' -f1)
				name=$(echo $d | cut -d'-' -f2)
				version=$(echo $d | cut -d'-' -f3)
				#call requirementMapBuilder
				otherRequirementMapBuilder $auth $name $version
			fi
		done


		#build a map of all packages that are diretcly or indirectly required by
		#the target package. This prevents removing directories not being used at all.

		while read -r dep; do
			targetRequirementMapBuilder $dep
		done < $libLoc$slash$1-$2-$3$slash$deps


		#for all packages in the second map but not the first remove them.
		for d in $( ls -d $libLoc$slash*/ ) ; do
			#check deps file to see if it is an ospm module.
			echo "targetDeps"
			echo `hget targetDeps $packageDir`
			echo "otherDeps"
			echo `hget otherDeps $packageDir`
			if [ ! -z `hget targetDeps $packageDir` ] && [ -z `hget otherDeps $packageDir` ]; then
				if [[ -f $d$slash$deps ]]; then
					rm -r $d
				fi
			fi
		done

		#remove target package.
		if [[ -f $libLoc$slash$packageDir$slash$deps ]]; then
			echo "deleting $libLoc$slash$packageDir"
			rm -r $libLoc$slash$packageDir
		fi

	else
		echo "Uninstall unsuccesful some error with library location or input."
	fi
	hinit targetDeps
	hinit otherDeps
}

function install {
	libLoc=$(cat /usr/local/lib/ospmLibSettings)
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

				if [ -f "$saveLoc$slash$deps" ]; then
					while read -r dep; do
						printf "${YELLOW}$dep\n${NC}"
						dep_dir=$libLoc$slash$dep
						if [ ! -z "$dep" ] && [ "$dep" != "\n" ]; then
							source ospm.sh install $dep
						fi
					done <$saveLoc$slash$deps
				fi

			else
				printf "${GREEN}$1-$2-$3 already installed$\n${NC}"
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
	install $2 $3 $4
	;;
	"uninstall" )
	uninstall $2 $3 $4
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
