if [ "$#" != 1 ]; then
	echo "Specify Directory Name!"
else
dir=$1
echo "GOING TO :: $dir"
pushd $dir
for f in *.png; do
	#idx=$(echo $f | sed -r 's@rgb/r-.*-([0-9]*).png@\1@')
	#mv $f rgb/$idx.png
	idx=$(echo $f | sed -r 's@.*-([0-9]*).png@\1@')
	idx=$(printf "%03d" $idx) # zero-pad
	#echo $f $idx
	mv $f $idx.png
done
popd
fi
