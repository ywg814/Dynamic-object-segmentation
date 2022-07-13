%% 绘制当前帧图像
function drawImage(I,frame_info, imagename, target_image, fp, frame, update_times, resultpath, mask_path, save_result)
figure(3)
clf()

[M, N] = size(I);
set(gcf,'position', [50 50 N M])
imshow(I, 'border', 'tight', 'initialmagnification','fit','DisplayRange',[0 255])
% imshow(I,[])
hold on
isDraw = [1 1 1 1 1 0 1];
% 绘制所有匹配点
% 绘制判定为目标的点
% 绘制判定为背景的点
% 绘制不同目标点
% 种子生成算法分割
% 是否保存图片



Legend = {};
is_match = frame_info.is_match(:, end);
points_track = frame_info.points_track(:,:,end) ;
targets_clusters = frame_info.targets_clusters(:, end);
% 绘制所有匹配点
if isDraw(1)
    
    scatter(points_track(is_match,1), points_track(is_match,2),'k.')
    Legend = [Legend 'All track points'];
end
% 判定为目标的点
if isDraw(2)
    target = ~isnan(targets_clusters) & ~isinf(targets_clusters);
    points = points_track(target,:);
    scatter(points(:,1), points(:,2),'b.')
    Legend = [Legend '聚类算法判定为目标的点'];
end
% 绘制聚类算法判定为背景的点
if isDraw(3)
    background = isinf(targets_clusters);
    points = points_track(background,:);
    scatter(points(:,1), points(:,2),'r.')
    Legend = [Legend '聚类算法判定为背景的点'];
end

% 绘制不同目标点
targets = frame_info.targets{end};
if isDraw(4)
    
    for i = 1:1:size(targets, 2)
        points = points_track(logical(targets(:,i)),:);
        scatter(points(:,1), points(:,2), '*')
        Legend = [Legend ['T ' num2str(i)]];
    end
end

% 背景减法
if isDraw(5)
    
end
% 是否绘制出航迹
if isDraw(6)
    if frame > 10
        points_track = frame_info.points_track(is_match,:,end-10:end) ;
        for i = 1:1:size(points_track,1)
            x(:) = points_track(i,1,:);
            y(:) = points_track(i,2,:);
            line(x,y,'color','r')
        end
    end
end
% legend(Legend)
% 是否保存图片
if save_result
    h1 = figure(1);
    saveas(h1,[resultpath '\' imagename(frame).name] );
%     h2 = figure(2);
    h2 = imshow(target_image,[]);
    saveas(h2,[mask_path imagename(frame).name] );
    fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', num2str(frame),num2str(sum(is_match)),num2str(size(targets, 2)), num2str(sum(sum(targets))), num2str(update_times));
end


pause(0.01)