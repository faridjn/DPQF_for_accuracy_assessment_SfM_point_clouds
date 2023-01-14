function [dist] = CalcDistance(P1, P2)

% find Euclidean distance between two point in 3D
xd = P1(1) - P2(1);
yd = P1(2) - P2(2);
zd = P1(3) - P2(3);
dist = sqrt(xd*xd + yd*yd + zd*zd);

end

