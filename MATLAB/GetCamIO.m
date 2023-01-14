function camIO  = GetCamIO(cameraXML)

% Construct variables to store XML reads
structCamIO = struct ('width',{}, 'height',{}, 'fx',{},'fy',{},'cx',{},'cy',{},'skew',{},'k1',{},'k2',{},'k3',{},'p1',{},'p2',{});

%preallocate
camIO = repmat(structCamIO,1);

% Read Interior Orinetation Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
camIO(1).height = str2double(cameraXML.document.chunk.sensors.sensor.calibration.resolution.Attributes.height);
camIO(1).width = str2double(cameraXML.document.chunk.sensors.sensor.calibration.resolution.Attributes.width);
camIO(1).fx = str2double(cameraXML.document.chunk.sensors.sensor.calibration.fx.Text);
camIO(1).fy = str2double(cameraXML.document.chunk.sensors.sensor.calibration.fy.Text);
camIO(1).cx = str2double(cameraXML.document.chunk.sensors.sensor.calibration.cx.Text);
camIO(1).cy = str2double(cameraXML.document.chunk.sensors.sensor.calibration.cy.Text);
camIO(1).skew = str2double(cameraXML.document.chunk.sensors.sensor.calibration.skew.Text);
camIO(1).k1 = str2double(cameraXML.document.chunk.sensors.sensor.calibration.k1.Text);
camIO(1).k2 = str2double(cameraXML.document.chunk.sensors.sensor.calibration.k2.Text);
camIO(1).k3 = str2double(cameraXML.document.chunk.sensors.sensor.calibration.k3.Text);
camIO(1).p1 = str2double(cameraXML.document.chunk.sensors.sensor.calibration.p1.Text);
camIO(1).p2 = str2double(cameraXML.document.chunk.sensors.sensor.calibration.p2.Text);

end
