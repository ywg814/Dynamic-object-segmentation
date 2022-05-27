 %% 对目标进行处理
function [curve,boundary]= deal_target(target,thr)
h = fspecial('average',5);
med_mean = filter2(h,target);
err_image = target - med_mean;

curve = err_image;

[Y1,X1] = find(curve>thr);%高于均值
[Y2,X2] = find(curve<-thr);%低于均值
curve(:) = 0;
curve(sub2ind(size(curve),Y1,X1)) = 2;
curve(sub2ind(size(curve),Y2,X2)) = 1;

% se=strel('disk',3);
% curve = imopen(curve,se);


ed = edge(target, 'canny', 0.1); 
boundary = double(ed);
% figure(1)
% imshow(boundary,[])