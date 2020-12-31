#export input_dir="/a/lib/samples/sketches"
#export input_dir="/a/lib/samples/content"
#export input_dir="/a/lib/datasets/gia-young-picasso-v04-2012211928_1024_p2p_canny/val"
export input_dir="/a/lib/datasets/gia-young-picasso-v04-2012211928-tii-v02-rogner-01-02-out_1024_p2p_canny"
export output_dir="/a/lib/results/tii-test/tii-v02-rogner-01-02-out_1024"
export trained_dir="/a/model/models/model_giapicallo_v04__201221-pix2pix-2012300846"

python pix2pix.py \
	--mode test \
	--output_dir "$output_dir" \
	--input_dir "$input_dir" \
	--checkpoint "$trained_dir"


