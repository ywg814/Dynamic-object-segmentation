
clc
clear
close all
%step1
melon_data = [randn(50,2)+ones(50,2);randn(50,2)-ones(50,2);randn(50,2)+[ones(50,1),-ones(50,1)]];
% melon_data(:,1)=[];
global delta_dist;
global min_pst;
delta_dist = 0.5; min_pst = 5;
object_set = search_objects(melon_data); %ok
%step2
[k_class,cluster_set]= repeat_Objects_clustering(melon_data,object_set);%ok
show(melon_data,cluster_set);
plot(object_set(:,1),object_set(:,2),'ro',...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',4)
fprintf('样本密度聚类个数为：%d\n',k_class);
