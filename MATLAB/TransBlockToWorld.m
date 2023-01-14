function XYZ_w = TransBlockToWorld(xyz_block, Rotation, Translation, scale)
XYZ_w = (scale * Rotation * (xyz_block)) + Translation;
end

% xyz_chunk = 1/scale * (Rotation \ (XYZ_w - Translation));
