%%  判断目标点是否满足速度场平面，满足速度场平面的点不认为是运动点
function frame_info = screeningMotionPoint(frame_info,frame)
v_sign = calVelocityFiled(frame_info);
frame_info.v_sign(:,frame) = v_sign;

targets_clusters = frame_info.targets_clusters;
targets_clusters(v_sign, end) = inf;

frame_info.targets_clusters = targets_clusters;

if 0
    points_track = frame_info.points_track(:,:,end) ;
    targets_clusters = frame_info.targets_clusters(:, end);
    
    target = ~isnan(targets_clusters) & ~isinf(targets_clusters);
    points = points_track(target,:);
    scatter(points(:,1), points(:,2),'b.')
    
    background = isinf(targets_clusters);
    points = points_track(background,:);
    scatter(points(:,1), points(:,2),'r.')
end