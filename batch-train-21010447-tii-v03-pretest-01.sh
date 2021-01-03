# Retrain the v01 by increasing resolution to 512 (CROP_SIZE)
mount_root="/a"
model_dir="$mount_root/model/models/model_gia-ds-tii-v03-acrypaint-yp-2101010250_1280_tst-01-512px"
trained_dir="$model_dir"
input_base_dir="$mount_root/lib/datasets/gia-ds-tii-v03-acrypaint-yp-2101010250_1280_tst-01"
input_dir="$input_base_dir/train"
output_test_dir="$input_base_dir/test"

mkdir -p $model_dir

#a first training to init the whole thing
python pix2pix.py --mode train --output_dir $model_dir --max_epochs 25 --input_dir $input_dir --which_direction BtoA   --display_freq 100

for i in 50 50 50 50 50 50 50 
	do
		python pix2pix.py --mode train --output_dir $model_dir --max_epochs $i --input_dir $input_dir --which_direction BtoA --checkpoint $trained_dir  --display_freq 100

		#test
		python pix2pix.py \
	--mode test \
	--output_dir "$output_test_dir" \
	--input_dir "$input_dir" \
	--checkpoint "$trained_dir"
done





