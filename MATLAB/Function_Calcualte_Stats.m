function Function_Calcualte_Stats( MAIN_FOLDER, fileName, FILTER_CRITERIA)

%calcualte and print stats
statsFile = fopen([MAIN_FOLDER 'stats_filter.xml'],'w');

%% READ DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dataReadFile = [MAIN_FOLDER fileName];
fprintf('Reading %s\n', dataReadFile);

% Read point cloud
%x y z Error distToFeature distToGCPs numProj aveAngInc aveRange brightIndex darkIndex
dataRead = load(dataReadFile);

%1:error, 2:d2feat, 3:d2gcp, 4:nImg, 5:angInc, 6:angSurf, 7:d2cam, 8:bright 9:dark
data = dataRead(:,4:end);

%% STATS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(statsFile,'Data: %s\n',dataReadFile);
fprintf(statsFile,'\n================= NO FILTER =====================\n');
fprintf(statsFile,'------------- STATS -------------\n');
fprintf(statsFile,'index\tRMS\tmean\tmedian\tstd\tmin\tmax\n');

for i = 1:9
    mean = nanmean(data(:,i));
    median = nanmedian(data(:,i));
    std = nanstd(data(:,i));
    max = nanmax(data(:,i));
    min = nanmin(data(:,i));
    RMS = sqrt(sumsqr(data(:,i))/size(data(:,i),1));
    fprintf(statsFile,'%d\t%f\t%f\t%f\t%f\t%f\t%f\n', i, RMS, mean, median, std, min, max);
end
%calculate correlation matrix
[R,P] = corrcoef(data,'rows','complete');

fprintf(statsFile,'------------- R  -------------\n');
for i = 1:9
    fprintf(statsFile,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', R(i,:));
end

fprintf(statsFile,'------------- P  -------------\n');
for i = 1:9
    fprintf(statsFile,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', P(i,:));
end

%% FILTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:2
      
   if k == 1
       nRMSE = 1.6166;

   else
       nRMSE = 1;
    end
    
    criteria =  nRMSE*FILTER_CRITERIA;
    
    %fomr a condition array with ones
        
    dataFilt = data(data(:,1)<criteria ,:);
    
    % Stat Filter data
    [R_filt,P_filt] = corrcoef(dataFilt,'rows','complete');
    fprintf(statsFile,'\n================= FILTER %0.3f =====================\n', criteria);
    fprintf(statsFile,'------------- STATS_FILT %0.3f -------------\n', criteria);
    fprintf(statsFile,'index\tRMS\tmean\tmedian\tstd\tmin\tmax\n');
    for i = 1:9
        mean = nanmean(dataFilt(:,i));
        median = nanmedian(dataFilt(:,i));
        std = nanstd(dataFilt(:,i));
        max = nanmax(dataFilt(:,i));
        min = nanmin(dataFilt(:,i));
        RMS = sqrt(sumsqr(dataFilt(:,i))/size(dataFilt(:,i),1));
        fprintf(statsFile,'%d\t%f\t%f\t%f\t%f\t%f\t%f\n', i, RMS, mean, median, std, min, max);
    end
    fprintf(statsFile,'------------- R filter %0.3f -------------\n', criteria);
    for i = 1:9
        fprintf(statsFile,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', R_filt(i,:));
    end
    
     fprintf(statsFile,'------------- P filter %0.3f -------------\n', criteria);
    for i = 1:9
        fprintf(statsFile,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', P_filt(i,:));
    end
    
end

%% Linear Regression
% Y = data(:,1);
% X1 = data(:,2);
% X2 = data(:,6);
% X = [X1 X2];
% lm = fitlm(X,Y);
%
%% PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Figure 1
% names = {'error','d2feat','d2gcp','nImg','angInc','angSurf','d2cam','bright','dark'};
% figure(1);clf
% corrplot(data,'varNames',names);
%
%% Figure 2
% addpath('X:\Farid\Publications\DPQF Paper\MATLAB\general-purpose-matlab-master');
% figure(2);clf
% names = {'error','d2feat','d2GCP','nImg','angInc','angSurf','d2cam','bright','dark'};
% corrplotheatmap(data,'strlabel',names);
%

fclose(statsFile);
fprintf('DONE!\n');

end

