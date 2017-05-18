#!/bin/bash

## DOWNLOAD DATA

function download_data(){
	local DATA_URL="http://tracking.cs.princeton.edu/ValidationSet.zip"
	local DATA_FILE="ValidationSet.zip"

	if [ ! -d data ] || [ ! -e data/${DATA_FILE} ]; then
		echo "Downloading Data ... "

		mkdir -p data
		pushd data
		wget ${DATA_URL} && unzip ${DATA_ZIP}
		popd

		for d in data/ValidationSet/*; do
			if [ -d ${d} ]; then
				../cvt.bash ${d}/rgb/
				../cvt.bash ${d}/depth/
				echo ${d}
			fi
		done
	else
		echo "Data Already Downloaded!"
	fi
}


## BUILD
function build_dskcf(){
	mkdir -p build
	pushd build
	cmake ../ -DCMAKE_BUILD_TYPE=Release
	make -j8
	popd
}

## RUN
function run_dskcf(){
	pushd build
	local bbox=$1
	local target=$2

	mkdir -p ../results/${target}
	./DSKCFTest -b ${bbox} -d -e ../results/${target} -o ../results/${target}/${target}.txt -s ../data/ValidationSet/${target}/rgb/ -i %.03d.png --depth_sequence ../data/ValidationSet/${target}/depth/ --depth_image_name_expansion %.03d.png
	popd
}

while test $# -gt 0
do
	case "$1" in
		--build|-b)
			build_dskcf
			;;
		--run|-r)
			shift
			case "$1" in
				bear)
					run_dskcf "178,162,121,156" bear_front
					;;
				child)
					run_dskcf "238,186,58,156" child_no1
					;;
				zcup)
					run_dskcf "236,295,73,139" zcup_move_1
					;;
				face)
					run_dskcf "242,186,79,101" face_occ5 
					;;
				new)
					run_dskcf "109,214,84,266" new_ex_occ4
					;;
				*)
					echo "invalid argument to run"
					;;
			esac

			;;
		--download|-d)
			download_data
			;;
		--help|-h)
			echo "===="
			echo -e "./run_bash"
			echo -e "\t [-b | --build] : build the project"
			echo -e "\t [-r | --run] [bear|child|zcup|face|new] : run the project"
			echo -e "\t [-d | --download] : download and the dataset"
			echo "===="
			;;
		--*) echo "bad option $1"
			;;
		*) echo "argument $1"
			;;
	esac
	shift
done
