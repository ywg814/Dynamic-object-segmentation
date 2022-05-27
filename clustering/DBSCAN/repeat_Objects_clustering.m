%step2
function [k_class,cluster_set]= repeat_Objects_clustering(melon_data,object_set)
cluster_set.k_rows =[];
cluster_set.cluster =[];
k=0;
t_data = melon_data;
while ~isempty(object_set)
    t_old_data = t_data; % not visit smample data
    [OS_rows,~] = size(object_set);
    Q = object_set(randi(OS_rows),:);
    del_ind = search_same_data(t_data,Q);
    t_data(del_ind,:)=[];
    while ~isempty(Q)
        [is_object, xi_object_samples] = core_engin(melon_data,Q(1,:));
        if is_object %>=min_pst
            delta_sample= set_across(t_data,xi_object_samples);
            if ~isempty(delta_sample)
                Q =[Q;delta_sample];
                t_data = set_diff(t_data,delta_sample);
            end
        end
        Q(1,:)=[];
    end
 k=k+1;
 cur_cluster = set_diff(t_old_data,t_data);
 object_set = set_diff(object_set,cur_cluster);
 %store
 [cur_cluster_rows,~] = size(cur_cluster);
 cluster_set.k_rows =[cluster_set.k_rows;cur_cluster_rows];
 cluster_set.cluster =[cluster_set.cluster;cur_cluster];
end
k_class = k;
end