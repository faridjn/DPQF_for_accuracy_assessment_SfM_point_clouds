function [uT, vT] = TransCamToThermal(u, v, camOptToThermal)
% find matching pixel in thermal image
uTvT = camOptToThermal \ [u; v; 1]; % uTvT = inv(camOptToThermal) * [u; v; 1];
uT = uTvT(1);
vT = uTvT(2);
end