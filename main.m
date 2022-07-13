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
imagetitle = 'egtest02';
%% 初始化参数
param
%% 初始化图像参数
frame = begin;
update_sign = true;    %是否更新
initialframe
update_sign = false;
%% 初始化存储结果
save_result = true;    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
initialSaveResult

%% processing
update_times = 0;    %更新次数
frame_refer = 1;    %参考帧的帧号
update_target = false(size(frame_info.SURFF_pin{1, 1}, 1), 1);
for frame = 2:1:frame_number
    
    Iout = read_image([imagepath imagename(frame).name]);
    ptsOut = detectSURFFeatures(Iout, 'MetricThreshold',parameter.SURFF_para);
    [featuresOut,validPtsOut]  = extractFeatures(Iout, ptsOut);
    Iout = double(Iout);
    
    figure(1)
    imshow(Iout,[])
    hold on
    
    % 初始化
    frame_info = match_points(featuresIn ,validPtsIn,featuresOut,validPtsOut,frame_info,frame);
    featuresIn = featuresOut;
    validPtsIn = validPtsOut;
    
    % KLT跟踪算法
    frame_info = KLT(frame_info,Iout,frame,update_sign);
    frame_info = deal_KLT_data(frame_info,frame);
    
    % 时间域滤波
    frame_info = temporalFiltering(frame_info,frame);
    
    % 判断目标点是否满足速度场平面，满足速度场平面的点不认为是运动点
    %     if frame_delta > 15    %存在一定的帧差后计算速度场
    frame_info = screeningMotionPoint(frame_info,frame);
    %     end
    
    % 当存在更新时，对目标点不判断放松
%     frame_info = ifUpdate(frame_info, update_target, frame_delta);
    
    % 空间聚类
    frame_info = spatialFiltering(frame_info, frame);
    
    % 利用特征点生成图像区域
    targets = frame_info.targets{end};
    targets_numbers = size(targets, 2);    %当前帧检测到的目标点数目
    target_image = zeros(size(Iout));
    if targets_numbers ~= 0
        [mask, frame_origin, original_composition] = detectObjects(frame_refer, Iout, frame_origin, original_composition, frame_info, frame);
        target_image = mask;
    end
    
    % 绘图
    drawImage(Iout, frame_info, imagename, target_image, fp, frame, update_times, resultpath, mask_path, save_result)
    
    % 是否更新点数据
    number_frame = sum(frame_info.is_match(:, frame));    %当前帧保存的跟踪点数目
    frame_delta = frame - frame_update;
    update_sign = updataSign(number_all, number_frame, frame_delta);
    if update_sign
        update_times = update_times + 1;
        %         frame_info_before_update = frame_info;
        initialframe;    %更新SURF点
        update_target = updataFrameInfomation(frame_info, mask, frame);
        update_sign = false;
        frame_refer = frame;
        origin = Iout;
    end
    
    
end
if save_result
    fclose(fp); %关闭文件
    fclose all;
end

function updata_sign = updataSign(number_all, number_frame, frame_delta)
% 是否需要更新
%{
number_all 上次更新后的总特征点数目
number_frame 当前帧存留的特征点数
frame_delta  距离上次更新后的帧数
%}

updata_sign = false;
if number_frame/number_all < 0.5 && frame_delta > 15    %0.3
    updata_sign = true;
end
end




