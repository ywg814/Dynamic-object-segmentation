%% 时间域滤波
function frame_info = temporalFiltering(frame_info,frame)
% 时间分类，分成三类：background target sus_target  背景 目标 疑似目标
[background, target, sus_target] = timeCluster(frame_info, frame);
frame_info.background = background;
frame_info.target = target;
frame_info.sus_target = sus_target;

%% 时间分类

function [background, target, sus_target] = timeCluster(frame_info, frame)
global parameter
thr = parameter.temporalFiltering_thr;
is_match = frame_info.is_match(:,frame);
background = frame_info.background;
target = frame_info.target;
sus_target = frame_info.sus_target;
background(:,frame) = false;
target(:,frame) = false;
sus_target(:,frame) = false;
% 以距离作为区分
distance = frame_info.L_L(is_match,frame);
Idx = myDBSCAN(distance);
% Idx = MeanShift_f(distance,radius);

% 分为背景和目标
background(is_match,frame) = Idx;

sus_target(is_match,frame) = ~Idx;

cc1 = frame_info.points_track(background(:,frame),:,frame);
cc2 = frame_info.points_track(sus_target(:,frame),:,frame);

temp = sum(sus_target(:,max(end-10,1):end),2) + sum(target(:,max(end-10,1):end),2);
c1 = (temp>thr);    %连续5帧不为背景判断为目标
c1 = c1 & sus_target(:,end);
target(c1,frame) = true;
sus_target(c1,frame) = false;

% 提取到的点
