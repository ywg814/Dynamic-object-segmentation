% 处理LLT航迹
function frame_info = deal_LLT_data(frame_info,frame)

fea = frame_info.LLT{frame_info.LLT_track.standard}.fea;
v_x = nan(size(fea,2),1);
v_y = nan(size(fea,2),1);
L_x = nan(size(fea,2),1);
L_y = nan(size(fea,2),1);
L_L = nan(size(fea,2),1);


logical_temp = frame_info.LLT{frame}.isFound;
logical1 = frame_info.LLT{frame-1}.isFound_allpoints;

% fea_old = frame_info.LLT{frame-1}.fea(logical_temp);
% fea_new = frame_info.LLT{frame}.fea;
% for i = 1:1:size(fea,2)
%     v_temp(i,:) = fea_new(i).points - fea_old(i).points;
% end
v_temp = frame_info.LLT{frame}.D;
logical1((logical1 == 1)) = logical_temp;
v_x(logical1) = v_temp(:,1);
v_y(logical1) = v_temp(:,2);
fea_old = frame_info.LLT{frame_info.LLT_track.standard}.fea(logical1);
fea_new = frame_info.LLT{frame}.fea;
L_temp = nan(size(fea_new ,2),2);
for i = 1:1:size(fea_new ,2)
    L_temp(i,:) = mean(fea_new(i).points - fea_old(i).points);
end
L_x(logical1) = L_temp(:,1);
L_y(logical1) = L_temp(:,2);
L_L(logical1) = L_x(logical1).^2 + L_y(logical1).^2;
frame_info.LLT{frame}.isFound_allpoints = logical1;
% 验算极线约束
% p1 = frame_info.LLT{frame_info.LLT_track.standard}.points_track(logical1,:);
% p2 = frame_info.LLT{frame}.points_track;
% [E, inlierIdx] = estimateFundamentalMatrix(p1,p2);
% d = computeDistance( p1, p2, E);%sampson
% temp = find(d<=1);
% inlierIdx(temp) = true;
% frame_info.LLT{frame}.E = E;
% frame_info.LLT{frame}.inlierIdx = inlierIdx;
% frame_info.LLT{frame}.d = d;


frame_info.LLT_track.v_x(:,frame) = v_x;
frame_info.LLT_track.v_y(:,frame) = v_y;
frame_info.LLT_track.L_x(:,frame) = L_x;
frame_info.LLT_track.L_y(:,frame) = L_y;
frame_info.LLT_track.L_L(:,frame) = L_L;
