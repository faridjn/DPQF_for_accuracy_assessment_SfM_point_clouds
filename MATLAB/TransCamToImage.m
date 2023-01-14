function [u, v] = TransCamToImage(xyz_camera, camIO)
        x = xyz_camera(1)/xyz_camera(3); % x=X/Z
        y = xyz_camera(2)/xyz_camera(3); % x=X/Z
        r = sqrt(x^2+y^2);
        
        % Brown's distortion
        x_prime = x * (1 + camIO.k1 * r^2 + camIO.k2 * r^4 ...
            + camIO.k3 * r^6) + camIO.p2 * (r^2 + 2*x^2) + 2*camIO.p1 *x*y;
        y_prime = y * (1 + camIO.k1 * r^2 + camIO.k2 * r^4 ...
            + camIO.k3 * r^6) + camIO.p1 * (r^2 + 2*y^2) + 2*camIO.p2 *x*y;
        
        % calculate image coordiantes of the point
        u = camIO.cx + x_prime * camIO.fx + y_prime * camIO.skew;
        v = camIO.cy + y_prime * camIO.fy;
end
