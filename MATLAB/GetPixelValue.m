function PixValue = GetPixelValue(image, uT, vT, band)
P = impixel(image,uT, vT);
PixValue = P(band);

if PixValue == 0
    PixValue = NaN;
end
end