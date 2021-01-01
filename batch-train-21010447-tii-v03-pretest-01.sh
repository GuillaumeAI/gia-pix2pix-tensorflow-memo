# Retrain the v01 by increasing resolution to 512 (CROP_SIZE)
model_dir="/a/model/models/model_gia-ds-tii-v03-acrypaint-yp-2101010250_1280_tst-01-512px"
input_dir="/a/lib/datasets/gia-ds-tii-v03-acrypaint-yp-2101010250_1280_tst-01/train"
mkdir -p $model_dir
python pix2pix.py --mode train --output_dir $model_dir --max_epochs 50 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100

python pix2pix.py --mode train --output_dir $model_dir --max_epochs 150 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100

# Continue so we have more checkpoints
python pix2pix.py --mode train --output_dir $model_dir --max_epochs 100 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100


