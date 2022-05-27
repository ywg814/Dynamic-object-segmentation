%³õÊ¼»¯Í¼ÏñÌØÕ÷
function   frame_info = cal_fea(frame_info,Iout,frame)
global thr;
thr = 5;
h = fspecial('average',5);
% med_mean = filter2(h,Iout);
bbox = frame_info.zone;
target = Iout(bbox(2):bbox(2)+bbox(4)-1,bbox(1):bbox(1)+bbox(3)-1);

[~,boundary] = deal_target(target,thr(1));
% fea = [];
fea = make_rec2(target,boundary,bbox);

frame_info.LLT{frame,1}.fea = fea;