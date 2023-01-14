function xyz_camera = TransBlockToCam(xyz_block, camEO)
rotation = camEO.extrinsic(1:3,1:3); % rotaion matrix
tranlation = camEO.extrinsic(1:3,4); % transformation matrix

%get coordinate of the point with respect to camera iCam
xyz_camera = rotation \ (xyz_block - tranlation);
end
