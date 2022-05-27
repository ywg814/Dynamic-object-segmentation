%% 时空聚类
function frame_info = space_time_clust(frame_info,frame)

% 分成三类：background target sus_target  背景 目标 疑似目标
background = frame_info.background;
target = frame_info.KLT_track.target;
sus_target = frame_info.KLT_track.sus_target;

background(:,frame) = false;
target(:,frame) = target(:,frame-1);
sus_target(:,frame) = false;
%% 时间分类
% 以距离作为区分
% time_p = frame_info.KLT_track.L_L(:,[1,frame]);
% time_p(:,1) = 1;
% time_p2 = time_p(frame_info.KLT{frame}.isFound_allpoints,:);
% radius=0.01*(max(time_p2(:,2) - min(time_p2(:,1))));



% 以位移作为区分


time_p2 = [frame_info.KLT_track.L_x(:,frame),frame_info.KLT_track.L_y(:,frame)];
time_p2 = time_p2(frame_info.KLT{frame}.isFound_allpoints,:);
radius = norm(0.3*[abs(max(time_p2(:,1))-min(time_p2(:,1))) abs(max(time_p2(:,2))-min(time_p2(:,2)))],2);


Idx = MeanShift_f(time_p2,radius);
num = max(Idx);
% 分类数目
num_temp = zeros(num,1);
for i = 1:1:num
    num_temp(i) = sum(Idx == i);
end
%
is_E  = background(:,end); % 判断是否满足极线约束
is_E(:) = false;
is_E(frame_info.KLT{frame}.isFound_allpoints) = frame_info.KLT{frame}.Inl;

for i = 1:1:num
    temp= find(Idx == i);
    l = false(size(Idx,2),1);
    
    logical_temp = frame_info.KLT{frame}.isFound_allpoints;
    if num_temp(i) >= max(num_temp)  %数量最多的集合,设置为背景
        l(temp) = true;
        logical_temp((logical_temp == 1)) = l;
        background(logical_temp,frame) = true;
    else
        l(temp) = true;
        logical_temp((logical_temp == 1)) = l;
        sus_target(logical_temp,frame) = true;
        
        
        temp = sum(sus_target(:,max(end-10,1):end),2);
        c1 = find(temp>5);
        target(c1,frame) = true;
        sus_target(c1,frame) = false;
    end
    
    
end

background(is_E,frame) = 1;
sus_target(is_E,frame) = 0;
% target(is_E,frame) = 0;
sus_target(target(:,frame),frame) = false;
background(target(:,frame),frame) = false;

frame_info.KLT_track.background = background;
frame_info.KLT_track.target = target;
frame_info.KLT_track.sus_target = sus_target;

%% 在目标点内空间滤波
cc1 = background(frame_info.KLT{frame}.isFound_allpoints,end);
cc2 = sus_target(frame_info.KLT{frame}.isFound_allpoints,end);
cc3 = target(frame_info.KLT{frame}.isFound_allpoints,end);
p_target = [frame_info.KLT{frame}.points_track(cc3,1) frame_info.KLT{frame}.points_track(cc3,2)];
if ~isempty(p_target)
%     radius = 40;
%     Idx = MeanShift_f(p_target,radius);
    Idx =myIsoData(p_target);
    frame_info.KLT{frame}.target_classification = Idx;
else
    Idx = 0;
end
targets = false(size(frame_info.KLT_track.L_L,1),max(Idx));
if sum(cc3)~=0
    for i = 1:1:max(Idx)
        temp = find(Idx == i);
        cc = find(target(:,end) == 1);
        targets(cc(temp),i) = true;
    end
    frame_info = integrated_target(frame_info,targets,frame);
end


% 
% figure(1)
% 
% scatter(frame_info.KLT{frame}.points_track(cc1,1),frame_info.KLT{frame}.points_track(cc1,2),'r')
% scatter(frame_info.KLT{frame}.points_track(cc2,1),frame_info.KLT{frame}.points_track(cc2,2),'g')
% color = 0.5*[    
%     0.8147    0.2760    0.1622
%     0.9058    0.6797    0.7943
%     0.1270    0.6551    0.3112
%     0.9134    0.1626    0.5285
%     0.6324    0.1190    0.1656
%     0.0975    0.4984    0.6020
%     0.2785    0.9597    0.2630
%     0.5469    0.3404    0.6541
%     0.9575    0.5853    0.6892
%     0.9649    0.2238    0.7482
%     0.1576    0.7513    0.4505
%     0.9706    0.2551    0.0838
%     0.9572    0.5060    0.2290
%     0.4854    0.6991    0.9133
%     0.8003    0.8909    0.1524
%     0.1419    0.9593    0.8258
%     0.4218    0.5472    0.5383
%     0.9157    0.1386    0.9961
%     0.7922    0.1493    0.0782
%     0.9595    0.2575    0.4427
%     0.6557    0.8407    0.1067
%     0.0357    0.2543    0.9619
%     0.8491    0.8143    0.0046
%     0.9340    0.2435    0.7749
%     0.6787    0.9293    0.8173
%     0.7577    0.3500    0.8687
%     0.7431    0.1966    0.0844
%     0.3922    0.2511    0.3998
%     0.6555    0.6160    0.2599
%     0.1712    0.4733    0.8001
%     0.7060    0.3517    0.4314
%     0.0318    0.8308    0.9106
%     0.2769    0.5853    0.1818
%     0.0462    0.5497    0.2638
%     0.0971    0.9172    0.1455
%     0.8235    0.2858    0.1361
%     0.6948    0.7572    0.8693
%     0.3171    0.7537    0.5797
%     0.9502    0.3804    0.5499
%     0.0344    0.5678    0.1450
%     0.4387    0.0759    0.8530
%     0.3816    0.0540    0.6221
%     0.7655    0.5308    0.3510
%     0.7952    0.7792    0.5132
%     0.1869    0.9340    0.4018
%     0.4898    0.1299    0.0760
%     0.4456    0.5688    0.2399
%     0.6463    0.4694    0.1233
%     0.7094    0.0119    0.1839
%     0.7547    0.3371    0.2400];
% if sum(cc3)~=0
%     for i = 1:1:size(frame_info.KLT_track.targets,2)
%         
%         sign = logical(frame_info.KLT_track.targets(:,i));
%         sign = sign(frame_info.KLT{frame}.isFound_allpoints);
% 
%         scatter(frame_info.KLT{frame}.points_track(sign,1),frame_info.KLT{frame}.points_track(sign,2),'filled','d','MarkerEdgeColor',color(i,:))
%     end
% end
% 
% legend('背景点','疑似点','目标点')



end