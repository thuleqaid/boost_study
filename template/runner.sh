#!/bin/bash

usage() {
	echo "Usage: `basename $0` action [target]"
	echo "  action: clean build rebuild"
	echo "  target: main test unittest-dir all"
	echo "          use 'main' if not specified"
	exit
}

clean() {
	if [ -d build ]
	then
		rm -rf build
	fi
}

rebuild() {
	clean
	mkdir build
	cd build
	cmake ..
	make
	cd ..
}

build() {
	if [ -d build ]
	then
		cd build
		make
		cd ..
	else
		mkdir build
		cd build
		cmake ..
		make
		cd ..
	fi
}

walk() {
	if [ $2 = "MAIN" ] || [ $2 = "ALL" ]
	then
		$1
	fi
	for item in unittest*
	do
		if [ -d $item ]
		then
			if [ $2 = "TEST" ] || [ $2 = "ALL" ] || [ $2 = "CUSTOM_$item" ]
			then
				cd ${item}
				$1
				cd ..
			fi
		fi
	done
}

if [[ $# < 1 ]]
then
	usage
fi
case "${1^^*}" in
	"CLEAN") action=clean;;
	"BUILD") action=build;;
	"REBUILD") action=rebuild;;
	*) action=clean;;
esac
if [[ $# < 2 ]]
then
	target="MAIN"
else
	case "${2^^*}" in
		"MAIN") target="MAIN";;
		"TEST") target="TEST";;
		"ALL") target="ALL";;
		*) target="CUSTOM_$2";;
	esac
fi
walk $action $target
