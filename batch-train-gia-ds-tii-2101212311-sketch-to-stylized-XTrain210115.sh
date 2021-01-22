# Continue the Retrain the v01 by increasing resolution to 512 (CROP_SIZE)
# Loop and test and train even more
# -------------------------------------------------

export model_dir="/a/model/models/model_gia-ds-tii-2101212311-sketch-to-stylized-XTrain210115"
export input_dir="/a/lib/datasets/gia-ds-tii-2101212311-sketch-to-stylized-XTrain210115/out_4096"
export trained_dir=$model_dir
#export output_test_dir=$input_dir/../test-2101220030
export output_test_dir=$model_dir/test-2101220030
#previous model
#export checkpoint="/a/model/models/model_gia-ds-tii-2101212311-sketch-to-stylized-XTrain210115"
export checkpoint=$model_dir

mkdir -p $model_dir
mkdir -p $output_test_dir

# We did started to train already
#python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA 

export max_epochs=45
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60; do 
	# Train the model for some epochs
	python pix2pix.py \
	--mode train --output_dir $model_dir \
	--max_epochs $max_epochs \
	--input_dir $input_dir --which_direction BtoA \
	--checkpoint $checkpoint  --display_freq 100


	# Render some tests for that iteration and continue training then
	export out_test_dir_iteration="$output_test_dir-$i"
	export test_input_dir="$input_dir"
	
	python pix2pix.py \
	--mode test \
	--output_dir "$out_test_dir_iteration" \
	--input_dir "$test_input_dir" \
	--checkpoint "$trained_dir"
	
	# Testing few iterations samples located in : gia-ds-tii-2101212311-sketch-to-stylized-XTrain210115/val/...
	for s in out_4096_crop_cc out_4096_crop out_4096
		do
			 # Test with few samples
        		export test_input_dir="$input_dir/../val/$s"
        		export out_test_dir_iteration="$output_test_dir-$i-val-$s"
       			python pix2pix.py \
        			--mode test \
        			--output_dir "$out_test_dir_iteration" \
        			--input_dir "$test_input_dir" \
        			--checkpoint "$trained_dir"
		
		done
#gia-ds-tii-2101212311-sketch-to-stylized-XTrain210115/val/out_4096_crop_cc

 
done
