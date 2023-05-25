# DDSeg: 

A **D**eep learning method for **D**iffusion MRI **Seg**mentation (DDSeg)


This code implements deep learning tissue segmentation method using diffusion MRI data, as described in the following paper:

    Fan Zhang, Anna Breger, Kang Ik Kevin Cho, Lipeng Ning, Carl-Fredrik Westin, Lauren O'Donnell, and Ofer Pasternak.
    Deep Learning Based Segmentation of Brain Tissue from Diffusion MRI
    NeuroImage 2021.

Please download the pre-trained CNN models and testing data: 

    https://github.com/zhangfanmark/DeepDWITissueSegmentation/releases

Download `Unet-DTI-n5-ATloss-GMWMCSF.zip` and `Unet-MKCurve-n10-ATloss-GMWMCSF.zip`, and uncompress them to the `CNN-models` folder.

Download `test_sub_CAP.zip` and `test_sub_HCP.zip`, and uncompress them to the `test` folder.

# Example
The code allows tissue segmentation using DTI parameters (single shell dMRI data) and using MKCurve (multi shell dMRI data with MKCurve corrected data). See scripts under the `test` folder for examples.
