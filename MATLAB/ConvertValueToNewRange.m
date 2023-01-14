function [ new ] = ConvertValueToNewRange( value, fromLow, fromHigh, toLow, toHigh)

new = double(0);
fromLow = double(fromLow);
fromHigh = double(fromHigh);
toLow = double(toLow);
toHigh = double(toHigh);


rangeOld = (fromHigh - fromLow);
if (rangeOld == 0)
    new = toLow;
else
    rangeNew = (toHigh - toLow);
    new = (((value - fromLow) * rangeNew) / rangeOld) + toLow;
end


