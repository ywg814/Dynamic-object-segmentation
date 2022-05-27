%% 按照是否满足极线约束分类
function draw_epipolar_constraint(frame_info,frame,Iin,sign)
figure(2)
clf()
imshow(Iin,[]);
hold on
for i = 1:1:size(frame_info.fea{frame},2)
    if sign(i) %满足极线约束
        scatter(frame_info.fea{frame}(i).points(frame_info.fea{frame}(i).sign_cross(:,end),1),frame_info.fea{frame}(i).points(frame_info.fea{frame}(i).sign_cross(:,end),2),'r');
    else
        scatter(frame_info.fea{frame}(i).points(frame_info.fea{frame}(i).sign_cross(:,end),1),frame_info.fea{frame}(i).points(frame_info.fea{frame}(i).sign_cross(:,end),2),'b');
    end
    
end
text(-100,10,'满足极线约束','Color','r');
title(['第' num2str(frame) '帧'])
end