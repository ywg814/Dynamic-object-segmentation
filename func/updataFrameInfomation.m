function update_target = updataFrameInfomation(frame_info, mask, frame)
% 更新特征点后，对检测到的点进行分类,
%{
frame_info    新产生的特征点
frame_info_before_update    之前的航迹信息
mask    当前帧目标位置
%}
% global parameter
% 
% [M, N] = size(mask);
points = frame_info.SURFF_pin{frame};
% for i = 1:1:size(points, 1)
%     [x, y] = deal(points(i, 1), points(i, 2));
%     
%     if mask(fix(y), fix(x))    %该点是目标上的点
%         frame_info.target(i, frame) = true;
%         frame_info.L_L(i, frame) = inf;    %更新后为在前一帧在目标上的点放一个初值
%         frame_info.L_x(i, frame) = inf;
%         frame_info.L_y(i, frame) = inf;
%     else
%         frame_info.L_L(i, frame) = 0;
%         frame_info.L_x(i, frame) = 0;
%         frame_info.L_y(i, frame) = 0;
%     end
%    
% end
update_target = false(size(points, 1));
for i = 1:1:size(points, 1)
    [x, y] = deal(points(i, 1), points(i, 2));
    
    if mask(fix(y), fix(x))    %该点是目标上的点
        update_target(i, 1) = true;
    else
         update_target(i,1) = false;
    end
   
end