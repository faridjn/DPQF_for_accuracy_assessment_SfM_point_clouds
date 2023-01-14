function xyz_block = TransWorldToBlock(XYZ_w, Rotation, Translation, Scale)
    xyz_block = 1/Scale * (Rotation \ (XYZ_w - Translation));
end