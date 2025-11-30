% Add function path
addpath(fullfile(fileparts(fileparts(mfilename('fullpath'))), 'functions'));

% LOAD ALL DATA
data_dir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), 'data', 'processed');
H14 = readtable(fullfile(data_dir, 'Output2014.csv')); 
H16 = readtable(fullfile(data_dir, 'Output2016.csv')); %present me is hoping future me is pleased with the
H20 = readtable(fullfile(data_dir, 'Output2020.csv')); %dataset we mined excruciatingly for in qgis
H24 = readtable(fullfile(data_dir, 'Output2024.csv'));

% STemp -- Surface Temperature
% QHumid -- Specific Humidity
% PSurf -- Surface Pressure
% avp -- Actual Vapor Pressure
% 0.622 is the ratio between the molecular weight of water vapor and dry air. Interesting stuff, I know.
% svp -- Saturation Vapor Pressure

% We are going to make HI - Heat Index in 5 easy steps
% Heat Index is important because it's how hot it actually feels, which is
% more relevant in heat illness cases and welfare than surface temperature.
disp("Original H16.STemp: ");
disp(H16.STemp);

% temperature is in Kelvin (the '.* 50' is because of data scientists)
% must convert to celsius for the "teten's formula" 
% but i will convert surface temperature to fahrenheit for plotting
STemp_C14 = H14.STemp .* 50 - 273.15;
STemp_C16 = H16.STemp .* 50 - 273.15;
STemp_C20 = H20.STemp .* 50 - 273.15;
STemp_C24 = H24.STemp .* 50 - 273.15;
disp("STemp_C16 after conversion: ");
disp(STemp_C16);

H14.STemp = ((9/5) .* STemp_C14) + 32; 
H16.STemp = ((9/5) .* STemp_C16) + 32;
H20.STemp = ((9/5) .* STemp_C20) + 32;
H24.STemp = ((9/5) .* STemp_C24) + 32; % also i know order of operations but it just gives me peace
disp("Fahrenheit H16.STemp: ");
disp(H16.STemp);
% - calculating relative humidity from specific humidity (kg/kg) and
% surface pressure (Pa)
    avp14 = (H14.QHumid .* H14.PSurf)./(0.622 + H14.QHumid);
avp16 = (H16.QHumid .* H16.PSurf)./(0.622 + H16.QHumid);
avp20 = (H20.QHumid .* H20.PSurf)./(0.622 + H20.QHumid);
avp24 = (H24.QHumid .* H24.PSurf)./(0.622 + H24.QHumid);
disp("avp");
disp(avp16);
% saturation vapor pressure. (Pa)
svp14 = 6.112 .* exp((17.67.*STemp_C14)./(STemp_C14+243.5)) .* 100;
svp16 = 6.112 .* exp((17.67.*STemp_C16)./(STemp_C16+243.5)) .* 10000; %messed up exporting some data
svp20 = 6.112 .* exp((17.67.*STemp_C20)./(STemp_C20+243.5)) .* 100;
svp24 = 6.112 .* exp((17.67.*STemp_C24)./(STemp_C24+243.5)) .* 100;
disp(svp16);
%relative humidity -- so close to heat index!!!
rh14 = (avp14 ./ svp14) .* 100;
rh16 = (avp16 ./ svp16) .* 100;
rh20 = (avp20 ./ svp20) .* 100;
rh24 = (avp24 ./ svp24) .* 100;

H14.HI = CalculateHeatIndex(STemp_C14,rh14);
H16.HI = CalculateHeatIndex(STemp_C16,rh16);
H20.HI = CalculateHeatIndex(STemp_C20,rh20);
H24.HI = CalculateHeatIndex(STemp_C24,rh24);

%% previous database code. i thought the datapoints were lousy and inconsistent. i sold my soul to qgis 
%   objective: matching coordinates to zipcodes in houston2020 from zip code information
% 
% zip2016 = Houston2016.ZIP;
% 
% lat2016 = round(Houston2016.LAT, 4);
% lng2016 = round(Houston2016.LONG,4);
% lat2020 = round(Houston2020.LAT, 4);
% lng2020 = round(Houston2020.LONG, 4);
% coords2016 = [lat2016,lng2016];
% coords2020 = [lat2020,lng2020];
% 
% Houston2020_Filtered = table();
% 
% numRows2016 = size(coords2016, 1);
% 
% for i = 1:numRows2016
%     distances = sqrt(sum((coords2020 - coords2016(i, :)).^2, 2));
%     [~, idxof2020] = min(distances);
%     matchedRow = Houston2020(idxof2020, :);
%     matchedRow.ZIP = Houston2016.ZIP(i);
%     Houston2020_Filtered = [Houston2020_Filtered; matchedRow];  
% end


%% 
H14.NHI = ((H14.HI - min(H14.HI))) / (max(H14.HI) - min(H14.HI));
H16.NHI = ((H16.HI - min(H16.HI))) / (max(H16.HI) - min(H16.HI));
H20.NHI = ((H20.HI - min(H20.HI))) / (max(H20.HI) - min(H20.HI));
H24.NHI = ((H24.HI - min(H24.HI))) / (max(H24.HI) - min(H24.HI));

H14.NSTemp = ((H14.STemp - min(H14.STemp))) / (max(H14.STemp) - min(H14.STemp));
H16.NSTemp = ((H16.STemp - min(H16.STemp))) / (max(H16.STemp) - min(H16.STemp));
H20.NSTemp = ((H20.STemp - min(H20.STemp))) / (max(H20.STemp) - min(H20.STemp));
H24.NSTemp = ((H24.STemp - min(H24.STemp))) / (max(H24.STemp) - min(H24.STemp));

% figure;
% geoplot(lat2020, lng2020);
% geobasemap satellite;
% heatIndex2020Map = geoscatter(lat2020, lng2020, Houston2020_Filtered.MarkerSize, Houston2020_Filtered.NHI, 'Marker', 'o');          
% 
% clim([prctile(Houston2020_Filtered.NHI, 5), prctile(Houston2020_Filtered.NHI, 95)])
% colormap('turbo');
% colorbar;
% title('Normalized Heat Index HeatMap 2020');

% % Enable datatips
% dcm = datacursormode(gcf);
% set(dcm, 'Enable', 'on', 'UpdateFcn', @(src, event) showHeatIndex(event, heatIndex2020Map, heatIndex20));

raw_dir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), 'data', 'raw');
save(fullfile(raw_dir, 'Houston2014.mat'),'H14');
save(fullfile(raw_dir, 'Houston2016.mat'),'H16');
save(fullfile(raw_dir, 'Houston2020.mat'),'H20');
save(fullfile(raw_dir, 'Houston2024.mat'),'H24');

disp('done');