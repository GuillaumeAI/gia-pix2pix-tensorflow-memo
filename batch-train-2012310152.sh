# Retrain the v01 by increasing resolution to 512 (CROP_SIZE)
model_dir="/a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846-512px"
input_dir="/a/lib/datasets/gia-young-picasso-v04-2012211928_1024_p2p_canny/train"
mkdir -p $model_dir
python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100

# Continue v01 to observe tomorrow what 50 EPOCS does in Qualities
model_dir="/a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846-512px"
input_dir="/a/lib/datasets/gia-young-picasso-v04-2012211928_1024_p2p_canny/train"
#mkdir -p $model_dir
#python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100

#python pix2pix.py --mode train --output_dir /a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846 --max_epochs 50 --input_dir /a/lib/datasets/gia-young-picasso-v04-2012211928_1024_p2p_canny/train --which_direction BtoA --checkpoint /a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846/  --display_freq 50

# Continue model v02 for a while 
model_dir="/a/model/models/model_gia-yp-tii-composite-v04-v05-2012310103-512px"
input_dir="/a/lib/datasets/gia-yp-tii-composite-v04-v05-2012310103/train"
mkdir -p $model_dir
python pix2pix.py --mode train --output_dir $model_dir --max_epochs 250 --input_dir $input_dir --which_direction BtoA --checkpoint $model_dir  --display_freq 100
#python pix2pix.py --mode train --output_dir /a/model/models/model_gia-yp-tii-composite-v04-v05-2012310103 --max_epochs 355 --input_dir /a/lib/datasets/gia-yp-tii-composite-v04-v05-2012310103/train --which_direction BtoA --checkpoint /a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846  --display_freq 50


