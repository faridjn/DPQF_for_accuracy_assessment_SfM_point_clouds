function [DarkFactor, BrightFactor ] = EstimateDarkBrightFactors(R,G,B)
 % get RGB values from pt cloud
        grayFromRGB = 0.2126 *R + .7152 * G + .0722 * B;
        grayIndex = ConvertValueToNewRange( grayFromRGB, 0, 255, -1, 1);

% input value is -1 < grayIndex < 1
% if grayIndex > 0 the point is bright 

if grayIndex > 0
    DarkFactor = 0;
    BrightFactor = grayIndex;
else
    BrightFactor = 0;
    DarkFactor = grayIndex;
end
end

