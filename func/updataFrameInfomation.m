function update_target = updataFrameInfomation(frame_info, mask, frame)
% ����������󣬶Լ�⵽�ĵ���з���,
%{
frame_info    �²�����������
frame_info_before_update    ֮ǰ�ĺ�����Ϣ
mask    ��ǰ֡Ŀ��λ��
%}
global parameter

[M, N] = size(mask);
points = frame_info.SURFF_pin{frame};
% for i = 1:1:size(points, 1)
%     [x, y] = deal(points(i, 1), points(i, 2));
%     
%     if mask(fix(y), fix(x))    %�õ���Ŀ���ϵĵ�
%         frame_info.target(i, frame) = true;
%         frame_info.L_L(i, frame) = inf;    %���º�Ϊ��ǰһ֡��Ŀ���ϵĵ��һ����ֵ
%         frame_info.L_x(i, frame) = inf;
%         frame_info.L_y(i, frame) = inf;
%     else
%         frame_info.L_L(i, frame) = 0;
%         frame_info.L_x(i, frame) = 0;
%         frame_info.L_y(i, frame) = 0;
%     end
%    
% end

for i = 1:1:size(points, 1)
    [x, y] = deal(points(i, 1), points(i, 2));
    
    if mask(fix(y), fix(x))    %�õ���Ŀ���ϵĵ�
        update_target(i, 1) = true;
    else
         update_target(i,1) = false;
    end
   
end