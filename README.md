# Installation #

- Clone repo
- download and extract FIJI - https://fiji.sc/
- run FIJI and download Particle Image Velocimetry plugin
   - help -> manage update sites
   - add update site - https://sites.imagej.net/iterativePIV/
        - note this is unlisted so you need to enter it manually
        - once you add you need to apply changes and restart ImageJ
        - PIV should now be listed in the plugins menu
- set paths in MATLAB
```
javaaddpath('D:\repos\matlab\AR-DIC\Src\Matlab_AR_DIC\AR_DIC\jar\mij.jar')
javaaddpath('C:\Users\jhokanson\Desktop\Fiji.app\jars\ij-1.54f.jar')
addpath('C:\Users\jhokanson\Desktop\Fiji.app\scripts')
```
- more paths :/ (not sure if the last one is needed)
```
addpath('D:\repos\matlab\AR-DIC\Src\Matlab_AR_DIC\AR_DIC\functions')
addpath('D:\repos\matlab\AR-DIC\Src\Matlab_AR_DIC\AR_DIC\main')
addpath('D:\repos\matlab\AR-DIC\Src\Matlab_AR_DIC\AR_DIC\objects')
addpath('D:\repos\matlab\AR-DIC\Src\Matlab_AR_DIC\AR_DIC')
```
- TODO: explain ffmpeg installation



# AR-DIC

Adaptive Reference-Digital Image Correlation (AR-DIC) enables unbiased and accurate mechanics measurements of moving biological tissue samples. Includes advanced tissue mechanical characterization and spatiotemporal analysis of cardiomyocyte beating for holistic measures of functional myocardial tissue development.

OVERVIEW

We developed an Adaptive Reference-Digital Image Correlation (AR-DIC) method which extends DIC capabilities enabling robust, unbiased, and accurate kinematics and strain measurements of biological samples which lack clear reference frames. Further, innovative tissue mechanical characterization and data visualization may lead to standardized measures of tissue mechanical functioning for lab-grown tissues and in-vivo diagnosis (i.e. photoacoustic imaging, ultrasound speckle tracking, magnetic resonance elastography: MRE). Together the novel DIC methods and tissue characterizations provide researchers and clinicians non-invasive tools for mechanobiology assessment. We applied these concepts to a difficult-to-characterize spontaneously beating cardiomyocyte (CM) tissue model assessing the localization, synchronization, and development of CM beating.


# CODE CONTENTS #

1. AR-DIC Matlab toolbox

    Demo and documentation files
    
2. Accumulative SpatioTemporal map visualization in Processing

    Demo and example files
    
3. Synthetic Topography visualization in Tangram

    Python local HTTP server script, Demo files


# CODE AVAILABLILITY #

Github: https://github.com/TheLimLab/AR-DIC


# LICENSE #

GNU General Public License V 3.0


# CITATION #

Akankshya Shradhanjali, Brandon D. Riehl, Bin Duan, Ruiguo Yang, Jung Yul Lim. Spatiotemporal characterizations of spontaneously beating cardiomyocytes with adaptive reference digital image correlation. Sci. Rep. In press. https://doi.org/10.1038/s41598-019-54768-w


# REPRODUCIBILITY #

Download our contracting and non-contracting video samples (links in Supplementary Information: https://doi.org/10.1038/s41598-019-54768-w). 

## Set the folder paths and run the following scripts to reproduce our main results: ##

main_AR_DIC.m

main_AR_DIC_process.m

main_AR_DIC_plotting.m


# SYSTEM REQUIREMENTS: #

## Hardware requirements (minimum): ##
2 processing cores at 2 GHz or greater
4GB RAM

## Software requirements ##
Tested operating systems:
Windows 7
Windows 10
MacOS Sierra

## AR-DIC requirements: ##

Matlab R2015a (v8.5) or higher is recommended. Tested on R2015a, R2018b.

### FFMPEG ##

This is required for many videos that are not readable by ImageJ.

Download the latest release at:
https://github.com/BtbN/FFmpeg-Builds/releases

Make sure to update the config to define **ffmpeg_root**


Matlab Image processing toolbox v9.2 or higher.

ImageJ/FIJI 1.51 or later (https://fiji.sc/)

MIJ (http://bigwww.epfl.ch/sage/soft/mij/)

Particle Image Velocimetry ImageJ plugin (https://sites.google.com/site/qingzongtseng/piv)

## ASTC Map requirements: ##

Processing version 3.3.4 or later with PeasyCam v.202 library or later

Synthetic Topography in Tangram requirements:

Tangram 0.11.7 or later. A complete simple demo is included with our code.

HTTP server. We recommend using Python 3.6 or later with the provided http host script.

