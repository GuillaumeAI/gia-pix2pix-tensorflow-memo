#!/bin/bash
ext=jpg
f=$1
o=$2



export fn=${f%.*};
export fo=${o%.*};

convert $f -crop 50%x0+0 $o'.'$ext 

