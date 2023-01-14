function [ xyz_c2 ] = TransBoresight( xyz_c1, boreSightRGB2TIR )

xyz_c2 =  boreSightRGB2TIR.R * (xyz_c1 + 1/1000.*boreSightRGB2TIR.T);

end

      
      
