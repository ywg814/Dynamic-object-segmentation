function show(melon_data,cluster_set)
plot(melon_data(:,1),melon_data(:,2),'+b');
hold on
cum_rows = cumsum(cluster_set.k_rows);
plot(cluster_set.cluster(1:cum_rows(1),1),cluster_set.cluster(1:cum_rows(1),2),'or');
plot(cluster_set.cluster(cum_rows(1)+1:cum_rows(2),1),cluster_set.cluster(cum_rows(1)+1:cum_rows(2),2),'sg');
plot(cluster_set.cluster(cum_rows(2)+1:cum_rows(3),1),cluster_set.cluster(cum_rows(2)+1:cum_rows(3),2),'^k');
plot(cluster_set.cluster(cum_rows(3)+1:end,1),cluster_set.cluster(cum_rows(3)+1:end,2),'pm');
xlabel('density');ylabel('sugar rate');
