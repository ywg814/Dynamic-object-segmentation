%% 计算原目标周围重构误差
function [fea,D,MIN] = cal_err_length(fea,srcimg)
% fea_new = [];
fea_temp = [];
D = [nan nan];
MIN = 0;
[M,N] = size(srcimg);
global gate;
if sum(fea.sign_length) == 0
    return
end
sign= fea.sign_length(:,end);
points = fea.points(sign,:);
if isempty(points)
    fea.sign_length(:,end+1) = fea.sign_length(:,end);
    return
end
num = size(points,1);
err = NaN(2*gate+1);
for dx = - gate :1:gate
    for dy = -gate:1:gate
        p_temp = points + repmat([dx,dy],num,1);
        [fea_temp,sign2] = fea_value(p_temp,srcimg,[1,1,N,M]);
        if sign2 ~= 0
            err(dy+gate+1,dx+gate+1) = norm(fea_temp.fea_length-fea.fea_length(sign,:),2);
        end
    end
end
MIN = min(err(:));
if isnan(MIN)
    D = [NaN,NaN];
    return
end
[D(1,2),D(1,1)] = find(err == MIN);
MIN = MIN/sum(sign);
%% 对每个点进行计算
D(1,:) = D(1,:) - gate - 1;
p_temp = points + repmat([D(1),D(2)],num,1);
[fea_temp,~] = fea_value(p_temp,srcimg,[1,1,N,M]);
% err = fea_temp.fea_length-fea.fea_length(sign,:);
% for i = 1:1:size(err,1)
%     e(i,1) = norm(err(i,:),2)/11;
% end

% p_temp = fea.points + repmat(D,fea.num,1);
% fea_temp = fea_value(p_temp,srcimg,[1,1,N,M]);
% fea_temp.pernorm = e;
fea_temp.MIN = MIN;
%% 更新fea_new
fea.fea_length(sign,:) = fea_temp.fea_length;
fea.sign_length(:,end+1) = sign;
fea.MIN= fea_temp.MIN;