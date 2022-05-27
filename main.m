%% ͼ����߼��
clear
clc
close all
warning off

addpath initial
addpath func
addpath track
addpath line_track
addpath fuse
addpath clustering/meanshift
addpath seed_generate
addpath clustering
fclose all
%% ������ʼ��
global parameter
parameterManagement()
global obj
%% select image
imagetitle = 'egtest01';
%% ��ʼ������
param
%% ��ʼ��ͼ�����
frame = begin;
updata_sign = true;    %�Ƿ����
initialframe
%% ��ʼ���洢���
initialSaveResult

%% processing

for frame = 2:1:frame_number+1
    
    Iout = read_image([imagepath imagename(frame).name]);
    ptsOut = detectSURFFeatures(Iout, 'MetricThreshold',parameter.SURFF_para);
    [featuresOut,validPtsOut]  = extractFeatures(Iout, ptsOut);
    Iout = double(Iout);
    
    %     figure(2)
    %     imshow(Iout,[])
    %     hold on

    % ��ʼ��
    frame_info = match_points(featuresIn ,validPtsIn,featuresOut,validPtsOut,frame_info,frame);
    featuresIn = featuresOut;
    validPtsIn = validPtsOut;
    
    % KLT�����㷨
    [frame_info, updata_sign] = KLT(frame_info,Iout,frame,updata_sign);
    frame_info = deal_KLT_data(frame_info,frame);
    
    % ʱ�����˲�
    frame_info = temporalFiltering(frame_info,frame);
    % �ж�Ŀ����Ƿ������ٶȳ�ƽ�棬�����ٶȳ�ƽ��ĵ㲻��Ϊ���˶���
    frame_info = screeningMotionPoint(frame_info,frame);
    % �ռ����
    frame_info = spatialFiltering(frame_info, frame);
    
    % ��������������ͼ������
    target_image = zeros(size(Iout));
    [centroids, bboxes, mask] = detectObjects(uint8(Iout));
    %    target_image = SeedGenerate(frame_info,target_image, Iout);
    
    % ��ͼ
    drawImage(Iout, frame_info, imagetitle, target_image, fp, frame, resultpath)
    
    % �Ƿ���µ�����
    if updata_sign
        initialframe;    %����SURF��
        updata_sign = false;
    end
end
fclose(fp); %�ر��ļ�
fclose all


