function [minT, maxT] = GetMinMaxFromStruct( imArrayTIR )
%GETMINMAXFROMSTRUCT Summary of this function goes here
%   Detailed explanation goes here

minArray = [];
maxArray = [];

for n = 1:size(imArrayTIR,2)
    arrayTIR = reshape(imArrayTIR{1,n}(:),[],1);
    minArray = [minArray min(arrayTIR(arrayTIR>0))];
    maxArray = [maxArray max(arrayTIR(arrayTIR<255))];
    
end
minT = min(minArray);
maxT = max(maxArray);
end

