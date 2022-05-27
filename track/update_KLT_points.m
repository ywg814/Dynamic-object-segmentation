% 重新检测点，刷新

function frame_info = update_KLT_points(frame_info, I,frame)
%% 保留
preserve = frame_info.KLT{end}.isFound_allpoints;
if sum(preserve)/size(preserve,1)>0.5
    return
end
frame_info.KLT{end}.isFound_allpoints  = frame_info.KLT{end}.isFound_allpoints(preserve);
frame_info.KLT{end}.isFound = frame_info.KLT{end}.isFound(frame_info.KLT{end}.isFound);

frame_info.KLT_track.is_target = frame_info.KLT_track.is_target(preserve,:);
frame_info.KLT_track.background = frame_info.KLT_track.background(preserve,:);
frame_info.KLT_track.target = frame_info.KLT_track.target(preserve,:);
frame_info.KLT_track.sus_target = frame_info.KLT_track.sus_target(preserve,:);

frame_info.KLT_track.v_x = frame_info.KLT_track.v_x(preserve,:);
frame_info.KLT_track.v_y = frame_info.KLT_track.v_y(preserve,:);
frame_info.KLT_track.L_x = frame_info.KLT_track.L_x(preserve,:);
frame_info.KLT_track.L_y = frame_info.KLT_track.L_y(preserve,:);
frame_info.KLT_track.L_L = frame_info.KLT_track.L_L(preserve,:);
frame_info.KLT_track.targets = frame_info.KLT_track.targets(preserve,:);


%% 新增
I = uint8(I);
ptsIn  = detectSURFFeatures(I);
[~ ,validPtsIn]  = extractFeatures(I,  ptsIn);
points = double(validPtsIn.Location);
points_standard = frame_info.KLT{end}.points_track;
m = size(points_standard,1);
for i = size(points,1):-1:1
    err = repmat(points(i,:),m,1) - points_standard;
    E = err(:,1).^2+err(:,2).^2;
    E = sqrt(E);
    if sum(E<1)>0
        points(i,:) = [];
    end
end


m = size(points,1);
new_true = true(m,1);
new_false = false(m,1);


frame_info.KLT{end}.points_track = [frame_info.KLT{end}.points_track;points];
frame_info.KLT{end}.isFound_allpoints  = [frame_info.KLT{end}.isFound_allpoints;new_true];

frame_info.KLT_track.is_target = [frame_info.KLT_track.is_target;new_false];
frame_info.KLT_track.background(end+1:end+m,end) = true;
frame_info.KLT_track.target(end+1:end+m,end) = false;
frame_info.KLT_track.sus_target(end+1:end+m,end) = false;

frame_info.KLT_track.v_x(end+1:end+m,end) = 0;
frame_info.KLT_track.v_y(end+1:end+m,end) = 0;
frame_info.KLT_track.L_x(end+1:end+m,end) = 0;
frame_info.KLT_track.L_y(end+1:end+m,end) = 0;
frame_info.KLT_track.L_L(end+1:end+m,end) = 0;

frame_info.KLT_track.targets(end+1:end+m,end) = false;

pointTracker = frame_info.KLT{end}.pointTracker;
% 跟踪特征点，有些点会丢失
setPoints(pointTracker, frame_info.KLT{end}.points_track);
frame_info.KLT{end}.pointTracker = pointTracker;

frame_info.KLT_track.standard = frame;

frame_info.KLT_track.relevance_begin(logical(eye(size(frame_info.KLT_track.relevance_begin)))) = frame;
