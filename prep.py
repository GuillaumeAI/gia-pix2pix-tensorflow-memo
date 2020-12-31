#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
@author: memo

loads bunch of images from a folder (and recursively from subfolders)
preprocesses (resize or crop, canny edge detection) and saves into a new folder
"""

from __future__ import print_function
from __future__ import division

import numpy as np
import os
import cv2
import PIL.Image

import argparse
# SEE in gia-pix2pix---....

parser = argparse.ArgumentParser(description='')
parser.add_argument('--root_path',
                    dest='root_path',
                    type=str,
                    default='/mnt/c/Users/jeang/Dropbox/lib/datasets',
                    help='Where your content folder is')

parser.add_argument('--in_path',
                    dest='in_path',
                    type=str,
                    default='gia-young-picasso-v04-2012211928-tii-v02-rogner-01-02',
                    help='Name of the content folder in root_path')
parser.add_argument('--out_path',
                    dest='out_path',
                    type=str,
                    default='gia-young-picasso-v04-2012211928-tii-v02-rogner-01-03-out',
                    help='Name of the content folder in ds_root')
parser.add_argument('--folder_suffix',
                    dest='folder_suffix',
                    type=str,
                    default='_p2p_canny',
                    help='Suffix to append to out. If not specified will add _p2p_canny.')
parser.add_argument('--dim',
                    dest='dim',
                    type=int,
                    default=1024,
                    help='dimension of out pic')
parser.add_argument('--canny_thresh1',
                    dest='canny_thresh1',
                    type=int,
                    default=100,
                    help='canny_thresh1- def 100')
parser.add_argument('--canny_thresh2',
                    dest='canny_thresh2',
                    type=int,
                    default=200,
                    help='canny_thresh1 - def 200')
parser.add_argument('--do_crop',
                    dest='do_crop',
                    type=bool,
                    default=False,
                    help=' if true, resizes shortest edge to target dimensions and crops other edge. If false, does non-uniform resize')

args = parser.parse_args()

dim = args.dim  # target dimensions, 
do_crop = args.do_crop # if true, resizes shortest edge to target dimensions and crops other edge. If false, does non-uniform resize

canny_thresh1 = args.canny_thresh1
canny_thresh2 = args.canny_thresh2

root_path = args.root_path
in_path = os.path.join(root_path, args.in_path)
out_path = os.path.join(root_path, args.out_path)


#########################################
out_path += '_' + str(dim) + args.folder_suffix
if do_crop:
    out_path += '_crop'

out_shape = (dim, dim)

if os.path.exists(out_path) == False:
    os.makedirs(out_path)

# eCryptfs file system has filename length limit of around 143 chars! 
# https://unix.stackexchange.com/questions/32795/what-is-the-maximum-allowed-filename-and-folder-size-with-ecryptfs
max_fname_len = 140 # leave room for extension


def get_file_list(path, extensions=['jpg', 'jpeg', 'png']):
    '''returns a (flat) list of paths of all files of (certain types) recursively under a path'''
    paths = [os.path.join(root, name)
             for root, dirs, files in os.walk(path)
             for name in files
             if name.lower().endswith(tuple(extensions))]
    return paths


paths = get_file_list(in_path)
print('{} files found'.format(len(paths)))


for i,path in enumerate(paths):
    path_d, path_f = os.path.split(path)
    
    # combine path and filename to create unique new filename
    out_fname = path_d.split('/')[-1] + '_' + path_f
                            
    # take last n characters so doesn't go over filename length limit
    out_fname = os.path.splitext(out_fname)[0][-max_fname_len+4:] + '.jpg'
    
    print('File {} of {}, {}'.format(i, len(paths), out_fname))
    im = PIL.Image.open(path)
    im = im.convert('RGB')
    if do_crop:
        resize_shape = list(out_shape)
        if im.width < im.height:
            resize_shape[1] = int(round(float(im.height) / im.width * dim))
        else:
            resize_shape[0] = int(round(float(im.width) / im.height * dim))
        im = im.resize(resize_shape, PIL.Image.BICUBIC)
        hw = int(im.width / 2)
        hh = int(im.height / 2)
        hd = int(dim/2)
        area = (hw-hd, hh-hd, hw+hd, hh+hd)
        im = im.crop(area)            
            
    else:
        im = im.resize(out_shape, PIL.Image.BICUBIC)
        
    a1 = np.array(im) 
    a2 = cv2.Canny(a1, canny_thresh1, canny_thresh2)
    a2 = cv2.cvtColor(a2, cv2.COLOR_GRAY2RGB)                 
    a3 = np.concatenate((a1,a2), axis=1)
    im = PIL.Image.fromarray(a3)                     
                       
    im.save(os.path.join(out_path, out_fname))

