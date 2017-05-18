#!/bin/bash

pushd build
make -j8
popd

function run_dskcf(){
	pushd build
	local bbox=$1
	local target=$2

	mkdir -p ../results/${target}
	./DSKCFcpp -b ${bbox} -d -e ../results/${target} -o ../results/${target}/${target}.txt -s ../data/ValidationSet/${target}/rgb/ -i %.03d.png --depth_sequence ../data/ValidationSet/${target}/depth/ --depth_image_name_expansion %.03d.png
	popd
}

#run_dskcf "178,162,121,156" bear_front
#run_dskcf "238,186,58,156" child_no1
#run_dskcf "236,295,73,139" zcup_move_1
#run_dskcf "242,186,79,101" face_occ5 
run_dskcf "109,214,84,266" new_ex_occ4

#./DSKCFcpp -b 178,162,121,156 -d -e ../results/bear/ -o ../results/bear/bear.txt -s ../data/ValidationSet/bear_front/rgb/ -i %.03d.png --depth_sequence ../data/ValidationSet/bear_front/depth/ --depth_image_name_expansion %.03d.png
#./DSKCFcpp -b 238,186,58,156 -d -e ../results/child/ -o ../results/child/child.txt -s ../data/ValidationSet/child_no1/rgb/ -i %.03d.png --depth_sequence ../data/ValidationSet/child_no1/depth/ --depth_image_name_expansion %.03d.png
