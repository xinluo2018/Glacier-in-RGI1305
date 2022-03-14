#! /bin/bash
## author: xin luo; xxxx
## create: 2022.03.12;
## des: DEM generation using aster stereo images. we take a L1A image for example
##      this is a simple example, details remain to be imporved by adjust setting.

data_dir=data/aster_data
path_file='data/aster_data/aster_raw_L1A/AST_L1A_00303142020052844_20220102025329_6217.zip'
files_tmp='data/aster_data/AST_L1A_00303142020052844'
dir_file=$(dirname $path_file)
name_file=$(basename $path_file)

mkdir $files_tmp
cp $path_file $files_tmp
unzip -q $files_tmp/$name_file -d $files_tmp   # unzip
rm $files_tmp/$name_file       #

## ---- processing using asp tool
# 1) parse the l1a aster data
aster2asp $files_tmp -o $files_tmp/out 

### 2) generate point cloud data
parallel_stereo -t aster --subpixel-mode 3 $files_tmp/out-Band3N.tif \
                    $files_tmp/out-Band3B.tif $files_tmp/out-Band3N.xml \
                    $files_tmp/out-Band3B.xml $files_tmp/pc_out/run

## 3) covert cloud point file to dem image
point2dem -r earth --tr 0.000277777777778 $files_tmp/pc_out/run-PC.tif -o $files_tmp/dem_out/run