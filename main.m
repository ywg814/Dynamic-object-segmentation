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
addpath background_subtraction
addpath vision
fclose all;
%% ������ʼ��
global parameter
parameterManagement()
global obj
%% select image
imagetitle = 'egtest02';
%% ��ʼ������
param
%% ��ʼ��ͼ�����
frame = begin;
update_sign = true;    %�Ƿ����
initialframe
update_sign = false;
%% ��ʼ���洢���
save_result = true;    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
initialSaveResult

%% processing
update_times = 0;    %���´���
frame_refer = 1;    %�ο�֡��֡��
update_target = false(size(frame_info.SURFF_pin{1, 1}, 1), 1);
for frame = 2:1:frame_number
    
    Iout = read_image([imagepath imagename(frame).name]);
    ptsOut = detectSURFFeatures(Iout, 'MetricThreshold',parameter.SURFF_para);
    [featuresOut,validPtsOut]  = extractFeatures(Iout, ptsOut);
    Iout = double(Iout);
    
    figure(1)
    imshow(Iout,[])
    hold on
    
    % ��ʼ��
    frame_info = match_points(featuresIn ,validPtsIn,featuresOut,validPtsOut,frame_info,frame);
    featuresIn = featuresOut;
    validPtsIn = validPtsOut;
    
    % KLT�����㷨
    frame_info = KLT(frame_info,Iout,frame,update_sign);
    frame_info = deal_KLT_data(frame_info,frame);
    
    % ʱ�����˲�
    frame_info = temporalFiltering(frame_info,frame);
    
    % �ж�Ŀ����Ƿ������ٶȳ�ƽ�棬�����ٶȳ�ƽ��ĵ㲻��Ϊ���˶���
    %     if frame_delta > 15    %����һ����֡�������ٶȳ�
    frame_info = screeningMotionPoint(frame_info,frame);
    %     end
    
    % �����ڸ���ʱ����Ŀ��㲻�жϷ���
%     frame_info = ifUpdate(frame_info, update_target, frame_delta);
    
    % �ռ����
    frame_info = spatialFiltering(frame_info, frame);
    
    % ��������������ͼ������
    targets = frame_info.targets{end};
    targets_numbers = size(targets, 2);    %��ǰ֡��⵽��Ŀ�����Ŀ
    target_image = zeros(size(Iout));
    if targets_numbers ~= 0
        [mask, frame_origin, original_composition] = detectObjects(frame_refer, Iout, frame_origin, original_composition, frame_info, frame);
        target_image = mask;
    end
    
    % ��ͼ
    drawImage(Iout, frame_info, imagename, target_image, fp, frame, update_times, resultpath, mask_path, save_result)
    
    % �Ƿ���µ�����
    number_frame = sum(frame_info.is_match(:, frame));    %��ǰ֡����ĸ��ٵ���Ŀ
    frame_delta = frame - frame_update;
    update_sign = updataSign(number_all, number_frame, frame_delta);
    if update_sign
        update_times = update_times + 1;
        %         frame_info_before_update = frame_info;
        initialframe;    %����SURF��
        update_target = updataFrameInfomation(frame_info, mask, frame);
        update_sign = false;
        frame_refer = frame;
        origin = Iout;
    end
    
    
end
if save_result
    fclose(fp); %�ر��ļ�
    fclose all;
end

function updata_sign = updataSign(number_all, number_frame, frame_delta)
% �Ƿ���Ҫ����
%{
number_all �ϴθ��º������������Ŀ
number_frame ��ǰ֡��������������
frame_delta  �����ϴθ��º��֡��
%}

updata_sign = false;
if number_frame/number_all < 0.5 && frame_delta > 15    %0.3
    updata_sign = true;
end
end




