%% 按照速度进行分类
function frame_info = cluster_D(frame_info,frame,Iin)

D = [frame_info.D{frame}(:,1),frame_info.D{frame}(:,2)];
sign_D = frame_info.sign_D{frame};
[~,A,B] = unique(D,'rows');
B(~sign_D) = 0;
frame_info.D_cluster{frame} = B;
if nargin==3
figure(1)
clf()
imshow(Iin,[]);
hold on
for i = 1:1:size(A,1)
    sign = find(B == i);
    color = rand(1,3);
    for j = 1:1:size(sign,1)
        scatter(frame_info.fea{frame}(sign(j)).points(frame_info.fea{frame}(sign(j)).sign_cross(:,end),1),frame_info.fea{frame}(sign(j)).points(frame_info.fea{frame}(sign(j)).sign_cross(:,end),2),'MarkerEdgeColor',color);
    end
    text(-100,10*i,['速度为：' num2str(D(A(i),:))],'Color',color);
    
end
title(['第' num2str(frame) '帧'])
end