%% 判断目标数目，是否合并
function frame_info = integrated_target(frame_info,targets,frame)
% 满足聚类，合并航迹、
frame_info = merger_track(frame_info,targets,frame);

% 不满足聚类，分裂航迹
frame_info = split_track(frame_info,targets,frame);







