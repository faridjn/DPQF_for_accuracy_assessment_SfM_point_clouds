function isInImage = IsInImage( u,v, width, height)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

if (u > 0) && (v > 0) && (u < width) && (v < height)
    isInImage= true;
else
    isInImage= false;
end

