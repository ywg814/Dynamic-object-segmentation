%% 计算inlierIdx，极线约束
function frame_info = cal_inlierIdx(frame_info,frame)

is_match = frame_info.is_match(:,frame);
p1 = frame_info.points_track(is_match,:,frame_info.refer);
p2 = frame_info.points_track(is_match,:,frame);
[E, inlierIdx] = estimateFundamentalMatrix(p1,p2);
d = computeDistance( p1, p2, E);%sampson
temp = (d<=0.5);
inlierIdx(temp) = true;
frame_info.E(:,:,frame) = E;

points_number = frame_info.points_number;
epipolar = false(points_number,1);
epipolar(is_match) = inlierIdx;


frame_info.epipolar(:,frame) = epipolar;