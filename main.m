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
addpath background_subtraction
addpath vision
fclose all;
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
update_times = 0;    %更新次数
frame_refer = 1;    %参考帧的帧号
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
    targets = frame_info.targets{end};
    targets_numbers = size(targets, 2);    %当前帧检测到的目标点数目
    target_image = zeros(size(Iout));
    if targets_numbers ~= 0
        [mask] = detectObjects(frame_refer, Iout, frame_origin, frame_info);
        target_image = mask;
    end
    
    % 绘图
    drawImage(Iout, frame_info, imagename, target_image, fp, frame, update_times, resultpath)
    
    % 是否更新点数据
    number_frame = sum(frame_info.is_match(:, frame));    %当前帧保存的跟踪点数目
    frame_delta = frame - frame_update;
    updata_sign = updataSign(number_all, number_frame, frame_delta);
    if updata_sign
        update_times = update_times + 1;
        frame_info_update = frame_info;
        initialframe;    %更新SURF点
        frame_info = updataFrameInfomation(frame_info, frame_info_update);
        updata_sign = false;
        frame_refer = frame;
        origin = Iout;
    end
    
    
end
fclose(fp); %关闭文件
fclose all;

function updata_sign = updataSign(number_all, number_frame, frame_delta)
% 是否需要更新
%{
number_all 上次更新后的总特征点数目
number_frame 当前帧存留的特征点数
frame_delta  距离上次更新后的帧数
%}

updata_sign = false;
if number_frame/number_all < 0.3 && frame_delta > 15
    updata_sign = true;
end
end

function frame_info = updataFrameInfomation(frame_info, frame_info_update)
% 更新特征点后，对检测到的点进行分类,
%{
frame_info    新产生的特征点
frame_info_update    之前的航迹信息
%}


end


