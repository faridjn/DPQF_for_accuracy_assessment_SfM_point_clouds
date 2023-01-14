function [ img_undist ] = Undistort_Image( img, camTermalCalib)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%construct K matric
Intrinsic = [camTermalCalib.camCalibIO.fc(1) 0 0
    0 camTermalCalib.camCalibIO.fc(2) 0
    camTermalCalib.camCalibIO.cc(1) camTermalCalib.camCalibIO.cc(2) 1];

%construct radial matrix
Radials = [camTermalCalib.camCalibIO.kc(1) camTermalCalib.camCalibIO.kc(1) camTermalCalib.camCalibIO.kc(1)];

%put camera parameters together
cameraParams = cameraParameters('IntrinsicMatrix', Intrinsic, 'RadialDistortion', Radials);

% undistort image
img_undist = undistortImage(img,cameraParams);

end

