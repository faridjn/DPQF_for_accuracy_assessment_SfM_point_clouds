function Function_Calcualte_DPQF_Langmack(MAIN_FOLDER)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Farid Javadnejad (nejad.fj@gmail.com)
% Created: 07/26/2017

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% FILES AND FOLDERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TO_WRITE_HEADER_LINE = 0;

% pointcloud file
fileDense3D   = [MAIN_FOLDER 'dense3d.txt']; % x y z r g b error Nx Ny Nz
fileDist2Feat = [MAIN_FOLDER 'dist2feat.txt']; % x y z distToFeatures
fileDist2GCP  = [MAIN_FOLDER 'dist2gcp.txt']; % x y z distToGCPs
fileCameraXML = [MAIN_FOLDER 'cameras.xml']; % camera IO and EO

%% %%%%%%%%%%%%%%%%%%%%%%%%% GET CAMERA PARAMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; format long g;

c = clock;
fprintf('--------------- START----------------\n%s\n%s', datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))),fileDense3D);

computerName = getenv('computername');

report = fopen([MAIN_FOLDER 'report.xml'],'w');
fprintf(report, '%s %s\n', computerName, datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fprintf(report, 'fileDense3D = %s\nfileDist2Feat = %s\nfileDist2GCP= %s\nfileCameraXML = %s\n',fileDense3D, fileDist2Feat,fileDist2GCP,fileCameraXML);
% READ CAMERA EO/IO AND CALIBRATION
cameraXML = xml2struct(fileCameraXML); % read camera EO and IO from an XML file to a structure

% GET PARAMS
camIO = GetCamIO(cameraXML);  % get Interior Orinetation Parameters
camEO = GetCamEO(cameraXML); % get Exterior Orinetation Parameters
[world_R, world_T, world_s] = GetWorldTransform(cameraXML);  % get Coordiante Transforamtion Matrix

nCam = size(cameraXML.document.chunk.cameras.camera,2); % number of images

%% %%%%%%%%%%%%%%%%%%%%%%%%% READ POINTCLOUD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initiate read file waitbar
readCloudWaitbar = waitbar(0,'Reading point cloud...');

% Read point cloud
dataCloud3D = load(fileDense3D);
dataDistToFeatures = load (fileDist2Feat);
dataDistToGCPs = load (fileDist2GCP);

% number if points
nPts = size(dataCloud3D, 1);

if (~(size(dataDistToFeatures, 1) == nPts) || ~(size(dataDistToGCPs, 1) == nPts))
    h = msgbox('Diffrence number of points in the inputs', 'Error','error');
    stop
end

% close read file waitbar
delete(readCloudWaitbar);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Messasge
c = clock;
fprintf(report,'Number of points = %d\n', nPts);
fprintf(report,'--------------------------------------------\n');
fprintf(report,'Started generating DPC-QF...\n%s\n', datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fprintf(report,'--------------------------------------------\n');

% Update waitbar
generateCloudWaitbar =waitbar(0,'Generating PC Quality Factors ...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(generateCloudWaitbar,'canceling',0);

%create a vectors to store Quality Factors
numOfProjFromImg = nan(nPts,1);
meanDistPtToCam = nan(nPts,1);
medianAngleOfInc =  nan(nPts,1);
angleOfSurf =  nan(nPts,1);
brightIndex = nan(nPts,1);
darkIndex = nan(nPts,1);

for pt = 1:nPts
    nProj = 0;
    distPtToCamReads = nan(0);
    angleOfIncReads = nan(0);
    
   % calculate brightness and darkness factor
    [darkIndex(pt), brightIndex(pt) ] = EstimateDarkBrightFactors(dataCloud3D(pt,4), dataCloud3D(pt,5), dataCloud3D(pt,6));

    %read world coordiante of the point
    XYZ_w = transpose(dataCloud3D(pt,1:3));
    
    %normal vector at point XYZ_w
    normV = dataCloud3D(pt,8:10);
    angleOfSurf(pt) = CalcAngOfInc(XYZ_w + [0; 0; 1000000], XYZ_w, normV);
    
    
    %get chuck coordinate
    xyz_block = TransWorldToBlock(XYZ_w, world_R, world_T, world_s);
    
    
    for iCam = 1: nCam
        
        %get coordinate of the point with respect to camera iCam
        xyz_c = TransBlockToCam(xyz_block, camEO(iCam));
        
        % calculate image coordiantes of the point
        [u, v] = TransCamToImage(xyz_c, camIO);
        
        if (IsInImage(u,v, camIO.width, camIO.height) == true) %in thermal
            % calculate camera location in world coordiainte system
            oCam_block = camEO(iCam).extrinsic(1:3,4);
            oCam_w = TransBlockToWorld(oCam_block, world_R, world_T, world_s) ;
            
            % agnle of incidence
            thisAngOfInc =  CalcAngOfInc(oCam_w, XYZ_w, normV);
            
            if thisAngOfInc < 90
            
            % add to number of projections
            nProj = nProj + 1;
            
            % consider that angle of incidene
            angleOfIncReads = [angleOfIncReads thisAngOfInc];
            
            % cosnider distance from point to camera
            distPtToCamReads = [distPtToCamReads CalcDistance(oCam_w, XYZ_w)];

            end
        end %if in image
        
    end %for iCam
    
    %convert intensity to absolute thermal value
    numOfProjFromImg(pt) = nProj;
    meanDistPtToCam (pt) = nanmean(distPtToCamReads);
    medianAngleOfInc(pt) = nanmedian(angleOfIncReads);
    
    %update waitbar
    if round(pt/nPts*100) > round((pt-1)/nPts*100)
        waitbar(pt/nPts,generateCloudWaitbar, sprintf('Generating PC Quality Factors ... (%0.0f%%)',100*pt/nPts));
        % Check for Cancel button press
        if getappdata(generateCloudWaitbar,'canceling')
            break
        end
    end
    
end %for pt
delete(generateCloudWaitbar);

wPts = pt; %store the number of pints corrently processed and use it for writing

%% %%%%%%%%%%%%%%%%%%%%%%% Write to file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c = clock;

% output pointcloud file
FILE_CLOUD_WRITE = [fileDense3D(1:end-4) '_PCQF.txt'];
fileID = fopen(FILE_CLOUD_WRITE,'w');
writeCloudWaitbar = waitbar(0,'Writing the PCQF indices......');
fprintf(report,'Started writing the PCQF indices......\n%s\n', datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));

if (TO_WRITE_HEADER_LINE == 1)
    fprintf(fileID, 'x y z Error distToFeature distToGCPs numProj meadAngInc meadAngSurf meanDistpToCam brightIndex darkIndex\n');
end
for pt = 1:wPts
    %(X Y Z) 1:Error 2:d2feat 3:d2gcp 4:numImg 5:andInc 6:angSurf 7:d2cam 8:bright 9:dark
    fprintf(fileID, '%.3f %.3f %.3f %.3f %.3f %.3f %d %.3f %.3f %.3f %.2f %.2f\n',...
        dataCloud3D(pt,1), dataCloud3D(pt,2), dataCloud3D(pt,3),...
        dataCloud3D(pt,7), dataDistToFeatures(pt,4), dataDistToGCPs(pt,4),...
        numOfProjFromImg(pt), medianAngleOfInc(pt), angleOfSurf(pt), meanDistPtToCam(pt),...
        brightIndex(pt), darkIndex(pt));
    
    %update waitbar
    if round(pt/wPts*100) > round((pt-1)/wPts*100)
        waitbar(pt/wPts,writeCloudWaitbar, sprintf('Writing the PCQF indices... (%0.0f%%)',100*pt/pt));
    end
end
delete(writeCloudWaitbar);

% close the file
fclose(fileID);
delete(findall(0,'Type','figure'));
c = clock;
fprintf(report,'--------------------------------------------\n');
fprintf(report,'Completed\n %s\n', datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));
fprintf(report,'********************************************\n');

fclose(report);
fprintf('\n--------------- DONE ----------------\n %s\n', datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6))));

end

