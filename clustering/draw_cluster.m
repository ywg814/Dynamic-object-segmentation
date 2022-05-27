%% »æÍ¼
function draw_cluster(S, Z)
figure(1);
n = size(S, 1);
legend_name = {};
for i = 1:1:n
    hold on
    scatter(S{i}(:,1), S{i}(:,2));
    legend_name = [legend_name ['µÚ' num2str(i) '×éÀà']];
end
legend(legend_name);
