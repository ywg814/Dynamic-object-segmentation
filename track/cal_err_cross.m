%% 计算原目标周围重构误差
function [fea,D,MIN] = cal_err_cross(fea,srcimg,gate)
% gate = 5;
fea_temp = [];
D = [nan nan];
MIN = 0;
[M,N] = size(srcimg);

if sum(fea.sign_cross) == 0
    return
end
sign= fea.sign_cross(:,end);
points = fea.points;
num = size(points,1);
err = NaN([2*gate+1,2*gate+1,1]);
for dx = - gate :1:gate
    for dy = -gate:1:gate
        p_temp = points + repmat([dx,dy],num,1);
        try
            [fea_temp,sign,sign2] = fea_value(p_temp,srcimg,sign,[1,1,N,M]);
        catch
            1;
        end
        if sign2 ~= 0
            err(dy+gate+1,dx+gate+1) = norm(fea_temp.fea_cross(sign,:)-fea.fea_cross(sign,:),2);
        end
    end
end
MIN = min(err(:));


if isnan(MIN)
    D = [NaN,NaN];
    return
end
try
    [temp1,temp2] = find(err == MIN);
    D(1,:) = [temp2(1) temp1(1)]; 
%     [D(1,2),D(1,1)] = find(err == MIN);
catch
    1;
end
MIN = MIN/sum(sign);
%% 对每个点进行计算
D(1,:) = D(1,:) - gate - 1;
p_temp = points + repmat([D(1),D(2)],num,1);
[fea_temp,~,~] = fea_value(p_temp,srcimg,sign,[1,1,N,M]);
% err = fea_temp.fea_cross-fea.fea_cross(sign,:);
% for i = 1:1:size(err,1)
%     e(i,1) = norm(err(i,:),2)/11;
% end

% p_temp = fea.points + repmat(D,fea.num,1);
% fea_temp = fea_value(p_temp,srcimg,[1,1,N,M]);
% fea_temp.pernorm = e;
fea_temp.MIN = MIN;
%% 更新fea_new
try
    fea.fea_cross(sign,:) = fea_temp.fea_cross(sign,:);
catch
    1
end
fea.sign_cross(:,end+1) = sign;
fea.MIN= fea_temp.MIN;
fea.points = p_temp;
