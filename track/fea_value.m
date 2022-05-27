function [fea,sign,sign2]= fea_value(p,target,sign,bbox)% [提取特征向量，判断直线点数少于5则忽略]
[m,n] = size(target);
sign2 = 1;
fea= [];
num_p = size(p,1);
p_temp = p+repmat(bbox(1:2),num_p,1)-1;

fea_cross = zeros(num_p,11);
fea_sign_cross = false(num_p,1);

fea_length = zeros(num_p,11);
fea_sign_length = false(num_p,1);

fea_num_cross = 0;
fea_num_length = 0;
for j = 1:1:num_p
    
    % cal_cross
    if p(j,1)<6||p(j,1)+6>n||p(j,2)<1||p(j,2)>m
        sign(j) = 0;
        continue
    else
        fea_num_cross = fea_num_cross + 1;
        try
            fea_cross(j,:) = cal_cross(p(j,:),target);
        catch
            1
        end
        fea_sign_cross(j,1) = true;
    end
end
if sum(sign) == 0||sum(sign)/size(sign,1)<0.5
    sign2 = 0;
    
    fea.fea_cross = fea_cross;
    fea.sign_cross = fea_sign_cross;
    fea.fea_length = fea_length;
    fea.sign_length = fea_sign_length;
    sign(:) = false;
    return
end
if fea_num_cross<5
    fea_sign_cross(:) = false;
end
if fea_num_length<5
    fea_sign_length(:) = false;
end

% Hu特征矩 耗时较长
% fea.fea_Hu = cal_Hu(target);

fea.points = p_temp;
fea.fea_cross = fea_cross;
fea.sign_cross = fea_sign_cross;
fea.fea_length = fea_length;
fea.sign_length = fea_sign_length;
fea.MIN = 0;
fea.update = 0;

%% 提取不同的图像特征
% 提取横向11个点像素值
function fea_cross = cal_cross(p,target)
fea_cross = target(p(1,2),p(1,1)-5:p(1,1)+5);

% 提取横纵向11个点像素值
function fea_cross = cal_length(p,target)
fea_cross = target(p(1,2)-5:p(1,2)+5,p(1,1))';
% Hu特征矩
function fea_Hu = cal_Hu(target)
fea_Hu = invariable_moment(target);
