%% Í¼Ïñ²ÎÊý
frame_info = [];
p_true = [0 0 0 0];
frame_info.target_position = p_true;
Iin = read_image([imagepath imagename(frame).name]);
if size(Iin,3) == 3
    Iin = rgb2gray(Iin);
end
ptsIn  = detectSURFFeatures(Iin,'MetricThreshold',parameter.SURFF_para);
[featuresIn ,validPtsIn]  = extractFeatures(Iin,  ptsIn);
[M,N] = size(Iin);
zone = [1,1,N,M];
Iin = double(Iin);

target = Iin;
frame_info.zone = zone;
frame_info = init_info(frame_info,validPtsIn.Location,validPtsIn.Location,zone,frame);

[frame_info, updata_sign] = KLT(frame_info,Iin,frame,updata_sign);

[M, N] = size(Iin);



