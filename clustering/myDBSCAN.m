%% 用于坐标点的聚类
function sign = myDBSCAN(data)
global parameter
myDBSCAN_thr = parameter.myDBSCAN_thr;
data_num = size(data,1);
[data_sort, data_index] = sort(data);
value = 1;
sign = zeros(data_num,1);
% Idx = false(data_num,1);
sign(1) = value;
data_err = data_sort(2:end) - data_sort(1:end-1);
data_err = sort(data_err);data_err(isinf(data_err)) = [];data_err(isnan(data_err)) = [];
thr = max([myDBSCAN_thr(1)*median(data_err) myDBSCAN_thr(2)*mean(data_err(end-10:end)) myDBSCAN_thr(3)*mean(data_err)]);
% thr = max([myDBSCAN_thr(1)*median(data_err) myDBSCAN_thr(3)*mean(data_err)]);

for i = 2:1:data_num
    err = abs(data_sort(i) - data_sort(i-1));
    if err < thr
        sign(i) = value;
    else
        value = value + 1;
        sign(i) = value;
    end
end
sign(data_index) = sign;

% cluster = zeros(value, 1);
% for i = 1:1:value
%     cluster(i) = sum(sign==i);
% end
% [back,~] = find(cluster==max(cluster));
% back = (sign==back');  % 寻找最大的类，作为背景
% back = logical(sum(back,2)); 
% Idx(data_index(back)) = true;
