function frame_info = KLT(frame_info,I,frame,updata_sign)
I = uint8(I);
if updata_sign
    % 角点
    points = double(frame_info.SURFF_pout{frame,1});
    pointTracker = vision.PointTracker('MaxBidirectionalError',3, 'NumPyramidLevels', 5,'BlockSize',[5,5], 'MaxIterations',50);
    initialize(pointTracker, points, I);
    frame_info.points_track = points;               % 
    frame_info.is_match = true(size(points,1),1);
    frame_info.pointTracker = pointTracker;
    points_number = size(points,1);
    frame_info.points_number = points_number;

    bbox = frame_info.target_position(1,:);
    is_true_target = false(size(points,1),1);
    for  i = 1:1:points_number
        if points(i,1)>bbox(1)&&points(i,1)<bbox(1)+bbox(3)&&points(i,2)>bbox(2)&&points(i,2)<bbox(2)+bbox(4)
            is_true_target(i,1) = true;
        end
    end
    frame_info.is_true_target = is_true_target;
    
    frame_info.targets_clusters(:,frame) = nan(points_number,1);
   
    frame_info.refer = frame;
    frame_info.targets = {};
%     frame_info.relevance = {};
%     frame_info.relevance_refer = {};
    
%     updata_sign = false;
    return
end
pointTracker = frame_info.pointTracker;
points_number = frame_info.points_number;
% 跟踪特征点，有些点会丢失
[points, isFound] = step(pointTracker, I);
visiblePoints = points(isFound, :);
oldPoints = visiblePoints;
setPoints(pointTracker, oldPoints);

is_match =  false(points_number,1);
is_match(frame_info.is_match(:,end),:) = isFound;
points_track = zeros(points_number,2);
points_track(is_match,:) = visiblePoints;

frame_info.points_track(:,:,frame) = points_track;

frame_info.is_match(:,frame) = is_match;

frame_info.pointTracker = pointTracker;

