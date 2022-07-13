%% ʱ�����˲�
function frame_info = temporalFiltering(frame_info,frame)
% ʱ����࣬�ֳ����ࣺbackground target  ���� Ŀ��
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

%% ʱ�����

function targets_clusters = timeCluster(frame_info, frame)
% global parameter
% thr = parameter.temporalFiltering_thr;
is_match = frame_info.is_match(:,frame);
targets_clusters = nan(frame_info.points_number, 1);
% ���˶�������Ϊ����
distance = frame_info.L_L(is_match,frame);
distance_cluster = myDBSCAN(distance);
% ���˶�������Ϊ����
theta = frame_info.L_theta(is_match,frame);
theta_cluster = myDBSCAN(theta);
% �ϲ�������
clusters = mergeCluster(distance_cluster, theta_cluster);

% ��Ϊ������Ŀ��
targets_clusters(is_match,frame) = clusters;


% �ϲ��˶�������˶�����ľ�����
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
back = (clusters==back');  % Ѱ�������࣬��Ϊ����
back = logical(sum(back,2));
clusters(back) = inf;

