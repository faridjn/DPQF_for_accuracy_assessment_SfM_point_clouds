function camEO  = GetCamEO(cameraXML)

nCam = size(cameraXML.document.chunk.cameras.camera,2); %number of images

% Construct variables to store XML reads
structCamEO = struct ('label', {}, 'extrinsic', {});

% preallocate
camEO = repmat(structCamEO,nCam);

for cam= 1: nCam
    textEO = strsplit(cameraXML.document.chunk.cameras.camera{1,cam}.transform.Text,' ');
    camEO(cam).extrinsic = [str2double(textEO{1,1})	str2double(textEO{1,2})	str2double(textEO{1,3})	str2double(textEO{1,4})
        str2double(textEO{1,5})	str2double(textEO{1,6})	str2double(textEO{1,7})	str2double(textEO{1,8})
        str2double(textEO{1,9})	str2double(textEO{1,10})	str2double(textEO{1,11})	str2double(textEO{1,12})
        str2double(textEO{1,13})	str2double(textEO{1,14})	str2double(textEO{1,15})	str2double(textEO{1,16})];
    
    camEO(cam).label = cameraXML.document.chunk.cameras.camera{1,cam}.Attributes.label;
end

end
