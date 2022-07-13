%% 时间域滤波
function frame_info = temporalFiltering(frame_info,frame)
% 时间分类，分成三类：background target  背景 目标
frame_info.targets_clusters = timeCluster(frame_info, frame);
if 1
    points_track = frame_info.points_track(:,:,end) ; 
    targets_clusters = frame_info.targets_clusters(:, end);
    
    background = isinf(targets_clusters);
    points = points_track(background,:);
    scatter(points(:,1), points(:,2),'r.')
    
    targets_clusters(isinf(targets_clusters)) = nan;
    for i = 1:1:max(targets_clusters)
        target = (targets_clusters == i);
        points = points_track(target,:);
        scatter(points(:,1), points(:,2),'*')
    end
    
   
    
end

%% 时间分类

function targets_clusters = timeCluster(frame_info, frame)
% global parameter
% thr = parameter.temporalFiltering_thr;
is_match = frame_info.is_match(:,frame);
targets_clusters = nan(frame_info.points_number, 1);
% 以运动距离作为区分
distance = frame_info.L_L(is_match,frame);
distance_cluster = myDBSCAN(distance);
% 以运动方向作为区分
theta = frame_info.L_theta(is_match,frame);
theta_cluster = myDBSCAN(theta);
% 合并聚类结果
clusters = mergeCluster(distance_cluster, theta_cluster);

% 分为背景和目标
targets_clusters(is_match,frame) = clusters;


% 合并运动方向和运动距离的聚类结果
function clusters = mergeCluster(distance_cluster, theta_cluster)
num_distance = max(distance_cluster);
num_theta = max(theta_cluster);
value = reshape(1:num_distance*num_theta,num_distance, num_theta);
clusters = zeros(num_distance, 1);
num = size(distance_cluster, 1);
for i = 1:1:num
    clusters(i) = value(distance_cluster(i), theta_cluster(i));
end

[~, ~, clusters] = unique(clusters);
for i = 1:1:max(clusters)
    cluster(i) = sum(clusters==i);
end
back = find(cluster==max(cluster));
back = (clusters==back');  % 寻找最大的类，作为背景
back = logical(sum(back,2));
clusters(back) = inf;

