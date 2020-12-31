docker pull jgwill/pix2pix:gia-pix2pix-tensorflow-memo;

nvidia-docker  run -it -d  --rm -p "6006:6006" -v $(pwd):/work -v /a/lib:/a/lib -v /a/model:/a/model jgwill/pix2pix:gia-pix2pix-tensorflow-memo

