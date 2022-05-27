%% 用于坐标点的聚类
function [Idx] = myIsoData(data)
global parameter
% 参数
para = parameter.myIsoData_para;

N = size(data, 1);
% 初始位置
Z(1,:) = data(1,:);
n = size(Z,1);

% 开始迭代
sign = 1;    %判断是否发生分裂，合并等
iteration = 0;
iteration_thr = para.I;
while sign && iteration < iteration_thr
    iteration = iteration + 1;
    sign = 0;
    % 根据聚类中心进行分类
    S = distributionPoint(Z, data);
    % 重新确定聚类中心,样本与聚类中心的距离
    [Z, D_ave_every, sigma] = calMeanStd(S);
    D_ave = mean(D_ave_every, 1);
    
    % 计算全部模式样本和其对应聚类中心的总平均距离D_mean
    n = size(Z,1);
    D_mean = cal_D_mean(S, D_ave_every,n, N);
    
    % 对每一个类进行分裂
    
    [S, Z, D_ave_every, para, sign] = split_all_cluster(S, Z, sigma,D_ave_every, n, D_mean,sign, para);
    
    n = size(Z,1);
    % 计算全部模式样本和其对应聚类中心的总平均距离D_mean
    D_mean = cal_D_mean(S, D_ave_every,n, N);
    
    % 对每一个类进行合并N_c 
    [S, Z, sign] = merge_cluster(S,Z,n,sign,para);
    n = size(Z,1);
    
end



for i = 1:1:N
    for j = 1:1:n
        if ismember(data(i,:), S{j},'rows')
            Idx(i) = j;
            break
        end
    end
end


%% 计算最小距离分配到不同聚类中心
function S = distributionPoint(Z, data)
center_point_numble = size(Z, 1);
data_numble = size(data, 1);
S{center_point_numble,1} = [];
for i = 1:1:center_point_numble
    for j = 1:1:data_numble
        length(i,j) = norm(Z(i,:)-data(j,:), 2);
    end
end
for j = 1:1:data_numble
    [~, idx] = min(length(:, j));
    S{idx,1}(end+1,:) = data(j,:);
end
trim = cellfun(@isempty,S);
S(trim) = [];


%% 计算每个类的均值方差
function [Z, D_ave_every, sigma] = calMeanStd(S)
n = size(S, 1);
for i = 1:1:n
    N_temp = size(S{i}, 1);
    Z(i,:) = 1/N_temp*sum(S{i}, 1);
    D_temp = 0;
    for j = 1:1:N_temp
        D_temp = D_temp + norm(S{i}(j,:) - Z(i,:), 2);
    end
    D_ave_every(i,:) = 1/N_temp*D_temp;
    sigma(i,:) = std(S{i},0,1);
end

%% 对类进行分裂
% 对每个类进行分裂
function [S, Z, D_ave_every, para, sign] = split_all_cluster(S, Z, sigma,D_ave_every, n,D_mean,sign,para)
S_temp = {};
Z_temp = [];
D_ave_every_temp = [];
for i = 1:1:n
    [S2, Z2, D_ave_every2, para, sign] = split_a_cluster(S{i}, Z(i,:), sigma(i,:), D_ave_every(i,:), D_mean,sign,para);
    S_temp = [S_temp;S2];
    Z_temp = [Z_temp;Z2];
    D_ave_every_temp = [D_ave_every_temp;D_ave_every2];
end
S = S_temp;
Z = Z_temp;
D_ave_every =  D_ave_every_temp;

% 对单个类进行分裂
function [S, Z, D_ave_every, para,  sign] = split_a_cluster(S, Z, sigma, D_ave_every,D_mean, sign, para)
theta_S = para.theta_S;
N_c = para.N_c;
theta_N = para.theta_N;
K = para.K;

k = 0.5;
N = size(S,1);
if max(sigma) > theta_S && (N > theta_N || N_c < K/2) %max(sigma) > theta_S && (N > theta_N  &&  D_ave_every >D_mean || N_c < K/2)
    sign = 1;
    
    if sigma(1)>sigma(2)
        bias =  k*[sigma(1) 0];
    else
        bias =  k*[0 sigma(1)];
    end
    
    Z1 = Z + bias;
    Z2 = Z - bias;
    N_c = N_c + 1;
    S = distributionPoint([Z1;Z2], S);
    [Z, D_ave_every, sigma] = calMeanStd(S);
    para.N_c = N_c;
end

%% 对类进行合并
function [S, Z, sign] = merge_cluster(S,Z,n,sign,para)
theta_c = para.theta_c;
N_c = para.N_c;


length = nan(n, n);
for i = 1:1:n
    for j = i+1:1:n
        length(i, j) = norm(Z(i,:) - Z(j,:), 2);           % 聚类中心距离
        length2 = nan;
        if length(i, j) > theta_c && length(i, j) < 1.5 * theta_c
            length2 = calculateMinDistance(S{i}, S{j});   % 聚类元素的最小距离 
        end
        length(i,j) = min(length(i, j), length2);
    end
end
[I, J] = find(length < theta_c);
if ~isempty(I)
    sign = 1;
    S_temp = {};
    Z_temp = [];
    while ~isempty(I)
        N_c = N_c - 1;
        S2 = [S{I(1)};S{J(1)}];
        S_temp = [S_temp;S2];
        S([I(1),J(1)]) = [];
        Z([I(1),J(1)],:) = [];
        a = I==I(1);
        b = J==J(1);
        length([I(1),J(1)], :) = [];
        length(:, [I(1),J(1)]) = [];
        [I, J] = find(length < theta_c);
    end
    [Z_temp, D_ave_every, sigma] = calMeanStd(S_temp);
    S = [S;S_temp];
    Z = [Z;Z_temp];
end
para.N_c = N_c;

%% 计算全部模式样本和其对应聚类中心的总平均距离D_men
function D_mean = cal_D_mean(S, D_ave_every,n, N)
D_mean = 0;
for i = 1:1:n
    D_mean = D_mean + D_ave_every(i)*size(S{i}, 1);
end
D_mean = D_mean / N;

%% 计算两组点的最小距离
function min_distance = calculateMinDistance(data1, data2)
num1 = size(data1,1);
num2 = size(data2,1);
distance = nan(num1,num2);
for i = 1:1:num1
    for j = 1:1:num2
        distance(i,j) = norm(data1(i,:) - data2(j,:), 2);
    end
end
min_distance = min(distance(:));

