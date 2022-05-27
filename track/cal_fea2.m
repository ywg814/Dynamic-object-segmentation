%% ÌáÈ¡Í¼ÏñÌØÕ÷
function fea = cal_fea2(srcimg,bbox,thr)%
h = fspecial('average',5);

med_mean = filter2(h,srcimg);
target = srcimg(bbox(2):bbox(2)+bbox(4)-1,bbox(1):bbox(1)+bbox(3)-1);

[~,boundary] = deal_target(target,thr(1));
% fea = [];
fea = make_rec2(target,boundary,bbox);

% fea = make_fea(rec,target);

% figure(1)
%  imshow(curve,[]);
 
