%% ͼ�����
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
tform = eye(3);
frame_info = init_info(frame_info,validPtsIn.Location,validPtsIn.Location,zone,frame, tform);

[frame_info, update_sign] = KLT(frame_info,Iin,frame,update_sign);

[M, N] = size(Iin);
frame_update = frame;    %����ʱ��֡��
number_all = frame_info.points_number;    %���º����������Ŀ
frame_delta = 0;

original_composition = [];    %���ɱ���ͼ��ɷ�
original_composition(:,:,1) = Iin;    %origin
%% ������������
% obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
%     'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);
% obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%     	'AreaOutputPort', true, 'CentroidOutputPort', true, ...
%         'MinimumBlobArea', 600);
%     
% [centroids, bboxes, mask] = obj.detector.step(uint8(Iin));    %��ʼ����һ֡
frame_origin = Iin;

