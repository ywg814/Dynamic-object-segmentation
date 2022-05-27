%% 利用特征点生成图像区域
function target_image = SeedGenerate(frame_info, target_image, I)
targets = frame_info.targets{frame};

points_track = frame_info.points_track(:,:,frame) ;
for i = 1:1:size(targets, 2)
    points = points_track(logical(targets(:,i)),:);
    target_image = mySeedGenerate(I, points, target_image, i);
end
