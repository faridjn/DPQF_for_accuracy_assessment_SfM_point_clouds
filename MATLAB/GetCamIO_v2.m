function camIO  = GetCamIO_v2(cameraXML)

% Construct variables to store XML reads
structCamIO = struct ('width',{}, 'height',{}, 'fx',{},'fy',{},'cx',{},'cy',{},'skew',{},'k1',{},'k2',{},'k3',{},'p1',{},'p2',{});

%preallocate
camIO = repmat(structCamIO,1);

% Read Interior Orinetation Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camIO(1).height = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.resolution.Attributes.height);
camIO(1).width = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.resolution.Attributes.width);
camIO(1).fx = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.fx.Text);
camIO(1).fy = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.fy.Text);
camIO(1).cx = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.cx.Text);
camIO(1).cy = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.cy.Text);
camIO(1).skew = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.skew.Text);
camIO(1).k1 = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.k1.Text);
camIO(1).k2 = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.k2.Text);
camIO(1).k3 = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.k3.Text);
camIO(1).p1 = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.p1.Text);
camIO(1).p2 = str2double(cameraXML.document.chunk.sensors.sensor.calibration{1,2}.p2.Text);

end
