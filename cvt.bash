function cvt(){
	if [ "$#" != 1 ]; then
		echo "Specify Directory Name!"
	else
		dir=$1
		echo "GOING TO :: $dir"
		pushd $dir
		for f in *.png; do
			#idx=$(echo $f | sed -r 's@rgb/r-.*-([0-9]*).png@\1@')
			#mv $f rgb/$idx.png
			idx=$(echo $f | sed -r 's@[r\|d]-[0-9]*-([0-9]*).png@\1@')
			idx=$(printf "%03d" $idx) # zero-pad
			if [ $? == 0 ]; then
				mv $f $idx.png
				#echo $f $idx
			else
				echo "cannot convert $f"
			fi
		done
		popd
	fi
}

cvt $@
