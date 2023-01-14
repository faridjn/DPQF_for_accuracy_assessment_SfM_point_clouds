
APP_FOLDER = strcat('X:\Farid\Publications\DPQF Paper\MATLAB\');
addpath(APP_FOLDER);

for j = 1:5
    
    %%%% FOLDERS
    if j == 1
        MAIN_FOLDER = 'Y:\Farid\Projects\2017-09-28 Langmack DPCQF\20171020_Langmack_04gcp\';
    elseif j == 2
        MAIN_FOLDER = 'Y:\Farid\Projects\2017-09-28 Langmack DPCQF\20171020_Langmack_06gcp\';
    elseif j == 3
        MAIN_FOLDER = 'Y:\Farid\Projects\2017-09-28 Langmack DPCQF\20171020_Langmack_08gcp\';
    elseif j == 4
        MAIN_FOLDER = 'Y:\Farid\Projects\2017-09-28 Langmack DPCQF\20171020_Langmack_12gcp\';
    else
        MAIN_FOLDER = 'Y:\Farid\Projects\2017-09-28 Langmack DPCQF\20171020_Langmack_18gcp\';
    end
    
    %%% FUNCITON
    cd(MAIN_FOLDER);
    
    if exist('report.xml', 'file')
        %skip
    else
        Function_Calcualte_DPQF_Langmack(MAIN_FOLDER);
    end
    
    
end
cd(APP_FOLDER);