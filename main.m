%% 图像的线检测
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
%% 参数初始化
global parameter
parameterManagement()
global obj
%% select image
imagetitle = 'egtest01';
%% 初始化参数
param
%% 初始化图像参数
frame = begin;
updata_sign = true;    %是否更新
initialframe
%% 初始化存储结果
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

    % 初始化
    frame_info = match_points(featuresIn ,validPtsIn,featuresOut,validPtsOut,frame_info,frame);
    featuresIn = featuresOut;
    validPtsIn = validPtsOut;
    
    % KLT跟踪算法
    [frame_info, updata_sign] = KLT(frame_info,Iout,frame,updata_sign);
    frame_info = deal_KLT_data(frame_info,frame);
    
    % 时间域滤波
    frame_info = temporalFiltering(frame_info,frame);
    % 判断目标点是否满足速度场平面，满足速度场平面的点不认为是运动点
    frame_info = screeningMotionPoint(frame_info,frame);
    % 空间聚类
    frame_info = spatialFiltering(frame_info, frame);
    
    % 利用特征点生成图像区域
    target_image = zeros(size(Iout));
    [centroids, bboxes, mask] = detectObjects(uint8(Iout));
    %    target_image = SeedGenerate(frame_info,target_image, Iout);
    
    % 绘图
    drawImage(Iout, frame_info, imagetitle, target_image, fp, frame, resultpath)
    
    % 是否更新点数据
    if updata_sign
        initialframe;    %更新SURF点
        updata_sign = false;
    end
end
fclose(fp); %关闭文件
fclose all


