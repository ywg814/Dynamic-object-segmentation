% 根据波门对结果进行修正
function frame_info = amendment_fea(frame_info,Iout,frame)
global gate;
fea = frame_info.LLT{frame-1}.fea;
% bbox = frame_info.zone;
wrong_points = [];


f_num = size(fea,2);
D = [];

parfor i = 1:1:f_num
    [fea_new(i),D(i,:),~] = cal_err_cross(fea(i),Iout,gate);
end
isFound = true(size(D,1),1);
check = (isnan(D(:,1)));
isFound(check) = false;
M = [fea_new.MIN];
check = (M>4);
isFound(check) = false;

frame_info.LLT{frame,1}.fea = fea_new(isFound);

frame_info.LLT{frame,1}.wrong_points = wrong_points;

frame_info.LLT{frame}.D = D(isFound,:);
frame_info.LLT{frame}.isFound = isFound;




