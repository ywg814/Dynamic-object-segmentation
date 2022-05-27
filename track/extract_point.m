% 提取需要验证极线约束的点
function [pin,pout] = extract_point(frame_info,frame)
num = size(frame_info.fea{frame},2);
pin = [];
pout = [];
for i = 1:1:num
     pin = [pin;frame_info.fea{frame-1}(i).points(frame_info.fea{frame-1}(i).sign_cross(:,end),:)];
     pout = [pout;frame_info.fea{frame}(i).points(frame_info.fea{frame}(i).sign_cross(:,end),:)];
end