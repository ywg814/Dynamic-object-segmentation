function frame_info = LLT(frame_info,I,frame,begin,vargin)
% I = uint8(I);
if frame == begin
    % 角点
    
    
    frame_info = cal_fea(frame_info,I,frame);
    fea = frame_info.LLT{end}.fea;
    frame_info.LLT{frame,1}.isFound = true(size(fea,2),1);
    frame_info.LLT{frame,1}.points_delete = [];
    
    
    logical1 = frame_info.LLT{frame}.isFound;
    frame_info.LLT{frame}.isFound_allpoints = logical1;
    bbox = frame_info.target(1,:);
    is_target = false(size(fea,2),1);
    for  i = 1:1:size(fea,2)
        if mean(fea(i).points(:,1))>bbox(1) && mean(fea(i).points(:,1))<bbox(1)+bbox(3) && mean(fea(i).points(:,2))>bbox(2)&&mean(fea(i).points(:,2))<bbox(2)+bbox(4)
            is_target(i,1) = true;
        end
    end
    frame_info.LLT_track.is_target = is_target;
    
    frame_info.LLT_track.background(:,frame) = true(size(is_target,1),1);
    frame_info.LLT_track.target(:,frame) = false(size(is_target,1),1);
    frame_info.LLT_track.sus_target(:,frame) = false(size(is_target,1),1);
    
    frame_info.LLT_track.standard = begin;
    
    frame_info.LLT_track.targets = [];
    frame_info.LLT_track.relevance = [];
    frame_info.LLT_track.relevance_begin = [];
    
    return
end
% pointTracker = frame_info.KLT{frame-1,1}.pointTracker;
% % 跟踪特征点，有些点会丢失
% [points, isFound] = step(pointTracker, I);
% visiblePoints = points(isFound, :);
% oldPoints = visiblePoints;
% setPoints(pointTracker, oldPoints);
frame_info = amendment_fea(frame_info,I,frame);











% frame_info.LLT{frame,1}.points_track =visiblePoints;
% frame_info.LLT{frame,1}.isFound = isFound;
% frame_info.LLT{frame,1}.points_delete = points(~isFound, :);
% frame_info.LLT{frame,1}.pointTracker = pointTracker;
