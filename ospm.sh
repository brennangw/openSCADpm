function library {
	if [[ "$1" == "save" ]]; then
		echo $2 > /usr/local/lib/ospmLibSettings
	else
		echo "Module library is:"
			cat /usr/local/lib/ospmLibSettings
        fi

}

function help {
        echo "Usage: ospm [-v] [-h] [library <> <>]"
        echo "-v                Show version"
        echo "-h                Show command line options"
        echo "library $2 $3         Save XXX in library"
}

function install {
	libLoc=$(cat /usr/local/lib/ospmLibSettings)
	if [[ ! -z $libLoc ]]; then
		slash=$(echo /)
		deps=$(echo dependencies)
		underscore_ospm=$(echo "_ospm")
		saveLoc=$libLoc$slash$1-$2-$3
		echo "save loc is below"
		echo $saveLoc
		echo $1
		echo $2
		echo $3
		if [ ! -d "$saveLoc" ]; then
			git clone -b $3  --single-branch --depth 1 https://github.com/$1/$2 $saveLoc
			# git clone https://github.com/$1/$2.git $saveLoc
			while read -r dep; do
				echo $dep
				dep_dir=$libLoc$slash$dep
				if [ ! -z "$dep" ] && [ "$dep" != "\n" ]; then
						source ospm.sh install $dep
				fi
			done <$saveLoc$slash$deps

		else
			echo "$1-$2-$3 already installed"
		fi


	else
		echo "Save the location of your installation library with: "
		echo "ospm library <location>"
		echo "ospm help has more information"
	fi
}

case "$1" in
	"library" )
     		library $2 $3
		;;
		"install" )
			install $2 $3 $4
		;;
    "-v" )
                echo "ospm 0.0.1"
                ;;

    "-h" )
                help
                ;;
	*)
        	echo "command not found";
esac
