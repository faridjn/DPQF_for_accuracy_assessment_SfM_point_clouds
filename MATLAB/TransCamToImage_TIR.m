function [ xp yp ] = TransCamToImage_TIR( xyz_c, IO)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = xyz_c(1)/xyz_c(3);
y = xyz_c(2)/xyz_c(3);

r = sqrt(x^2 + y^2);
xd = x*(1+IO.kc(1)*r^2 + IO.kc(2)*r^4 + IO.kc(5)*r^6) + ...
    2*IO.kc(3)*x*y + IO.kc(4)*(r^2 + 2*x^2);
yd = y*(1+IO.kc(1)*r^2 + IO.kc(2)*r^4 + IO.kc(5)*r^6) + ...
    IO.kc(3)*(r^2+2*y^2) + 2*IO.kc(4)*x*y;

xp = IO.fc(1)*(xd+ IO.alpha_c* yd )+IO.cc(1);
yp = IO.fc(2) * yd + IO.cc(2);

end
