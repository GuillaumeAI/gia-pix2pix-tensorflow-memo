docker pull jgwill/pix2pix:gia-pix2pix-tensorflow-memo;
export mount_root=/a
export container_tag=jgwill/pix2pix:gia-pix2pix-tensorflow-memo

nvidia-docker  run -it -d  --rm -p "6006:6006" -p "8000:8000" -p "8080:8080" -v $(pwd):/work -v $mount_root/lib:/a/lib -v $mount_root/model:/a/model $container_tag


