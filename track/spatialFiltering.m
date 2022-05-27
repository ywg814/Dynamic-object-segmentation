%% 在目标点内空间滤波
function frame_info = spatialFiltering(frame_info, frame)
targets = spatialCluster(frame_info, frame);
frame_info.targets{frame} = targets;
% 航迹拆分合并
% frame_info = integrated_target(frame_info, targets, frame);

%% 空间分类
function targets = spatialCluster(frame_info, frame)
points_number = frame_info.points_number;
target = frame_info.target(:,end);
p_target = [frame_info.points_track(target,1,frame) frame_info.points_track(target,2,frame)];
if ~isempty(p_target)
    Idx =myIsoData(p_target);
    frame_info.KLT{frame}.target_classification = Idx;
else
    Idx = 0;
end
targets = false(points_number,max(Idx));
if sum(target)~=0
    for i = 1:1:max(Idx)
        target_temp = target(:,end);
        target_temp(target_temp) = (Idx == i);
        targets(target_temp,i) = true;
    end
end