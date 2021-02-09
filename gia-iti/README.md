# Cross Platform Image To Image Translation (ITI) Command Wrapper

* Receive an input image and translate it to an output image using command line on any platform

# Install 

```sh
npm i gia-iti --g
# Preload the image
docker pull jgwill/
```
## Environment install and models

* First you are required to have a trained model somewhere in your computer

### Environment var thru .bashrc

```bash
#model
export model_dir=/mnt/c/model/models

#ITI
export model_dir_iti=$model_dir/model_gia-ds-tii-2102011823-enginepart-v01-XTrain2102011823-64ik
```


# Prereq

* [Docker](https://www.docker.com/get-started?)
* [NodeJS](https://nodejs.org/en/download/)


