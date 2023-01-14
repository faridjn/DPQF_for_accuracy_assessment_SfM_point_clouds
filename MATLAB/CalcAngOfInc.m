function [ angle ] = CalcAngOfInc(pA, pB, Npt)
v = [(pA(1) - pB(1)); (pA(2) - pB(2)); (pA(3) - pB(3))];
Nv = v / norm(v);
angle = atan2d(norm(cross(Npt,Nv)),dot(Npt,Nv));
end

