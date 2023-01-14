fileName = 'dense3d_PCQF.txt';
FILTER_CRITERIA  = 100; %no filter

%%%%%%%%%%%%%%%%%%%%%
APP_FOLDER = strcat('X:\Farid\Publications\DPQF Paper\MATLAB\');
addpath(APP_FOLDER);
cd(APP_FOLDER);


for j = 1:3
    if j == 1
        Scenario = 'A';
    elseif j==2
        Scenario = 'B';
    else
        Scenario = 'C';
    end
    
    for i = 1:5
        
        MAIN_FOLDER = strcat('U:\presentations\Farid\20170920_DPQF\SIMULATION_', Scenario, num2str(i), '\proc\results\setting01\las_v2\');
        cd(MAIN_FOLDER);
        
        if exist('stats.xml', 'file')
            %skip
        else
            Function_Calcualte_Stats(MAIN_FOLDER, fileName, FILTER_CRITERIA);
        end
        
    end
end
cd(APP_FOLDER);