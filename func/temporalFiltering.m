%% ʱ�����˲�
function frame_info = temporalFiltering(frame_info,frame)
% ʱ����࣬�ֳ����ࣺbackground target sus_target  ���� Ŀ�� ����Ŀ��
[background, target, sus_target] = timeCluster(frame_info, frame);
frame_info.background = background;
frame_info.target = target;
frame_info.sus_target = sus_target;

%% ʱ�����

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
% �Ծ�����Ϊ����
distance = frame_info.L_L(is_match,frame);
Idx = myDBSCAN(distance);
% Idx = MeanShift_f(distance,radius);

% ��Ϊ������Ŀ��
background(is_match,frame) = Idx;

sus_target(is_match,frame) = ~Idx;

cc1 = frame_info.points_track(background(:,frame),:,frame);
cc2 = frame_info.points_track(sus_target(:,frame),:,frame);

temp = sum(sus_target(:,max(end-10,1):end),2) + sum(target(:,max(end-10,1):end),2);
c1 = (temp>thr);    %����5֡��Ϊ�����ж�ΪĿ��
c1 = c1 & sus_target(:,end);
target(c1,frame) = true;
sus_target(c1,frame) = false;

% ��ȡ���ĵ�