function [R, T, S] = GetWorldTransform(camEO)
% rotation matrix

GeoRef = isfield(camEO.document.chunk, 'transform'); %check if geo-refrenced

if (GeoRef)
    
    textR = (strsplit(camEO.document.chunk.transform.rotation.Text,' '));
    R = [str2double(textR{1,1}) str2double(textR{1,2}) str2double(textR{1,3})
        str2double(textR{1,4}) str2double(textR{1,5}) str2double(textR{1,6})
        str2double(textR{1,7}) str2double(textR{1,8}) str2double(textR{1,9})];
    
    % translate matrix
    textT = (strsplit(camEO.document.chunk.transform.translation.Text, ' '));
    
    
    T = [str2double(textT{1,1}); str2double(textT{1,2}); str2double(textT{1,3})];
    
    % scale
    textS = strsplit(camEO.document.chunk.transform.scale.Text, ' ');
    S = str2double(textS{1,1});
    
else
    R = [1 0 0
        0 1 0
        0 0 1];
    T = [0;0; 0];
    S = 1;
end

end
