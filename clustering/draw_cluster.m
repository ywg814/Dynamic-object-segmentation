%% ��ͼ
function draw_cluster(S, Z)
figure(1);
n = size(S, 1);
legend_name = {};
for i = 1:1:n
    hold on
    scatter(S{i}(:,1), S{i}(:,2));
    legend_name = [legend_name ['��' num2str(i) '����']];
end
legend(legend_name);
