%% ���Ƶ�ǰ֡ͼ��
function drawImage(I,frame_info, imagename, target_image, fp, frame, resultpath)
figure(1)
clf()

[M, N] = size(I);
set(gcf,'position', [50 50 N M])
imshow(I, 'border', 'tight', 'initialmagnification','fit','DisplayRange',[0 255])
% imshow(I,[])
hold on
isDraw = [1 0 0 1 0 0 1];    
% ��������ƥ��� 
% �����ж�ΪĿ��ĵ� 
% �����ж�Ϊ�����ĵ� 
% ���Ʋ�ͬĿ���
% ���������㷨�ָ�
% �Ƿ񱣴�ͼƬ



Legend = {};
is_match = frame_info.is_match(:, end);
points_track = frame_info.points_track(:,:,end) ;
% ��������ƥ���
if isDraw(1)
    
    scatter(points_track(is_match,1), points_track(is_match,2),'k.')
    Legend = [Legend 'All track points'];
end
% �ж�ΪĿ��ĵ�
if isDraw(2)
    target = frame_info.target(:,end);
    target = target(isFound_allpoints);
    points = points_track(target,:);
    scatter(points(:,1), points(:,2),'b*')
    Legend = [Legend '�����㷨�ж�ΪĿ��ĵ�'];
end
% ���ƾ����㷨�ж�Ϊ�����ĵ�
if isDraw(3)
    background = frame_info.background(:,end);
    points = points_track(background,:);
    scatter(points(:,1), points(:,2),'r.')
    Legend = [Legend '�����㷨�ж�Ϊ�����ĵ�'];
end

% ���Ʋ�ͬĿ���
targets = frame_info.targets{end};
if isDraw(4)
    
    for i = 1:1:size(targets, 2)
        points = points_track(logical(targets(:,i)),:);
        scatter(points(:,1), points(:,2), '*')
        Legend = [Legend ['T ' num2str(i)]];
    end
end

% ���������㷨�ָ�
if isDraw(5)
    figure(2)
    imshow(target_image,[])
end
% �Ƿ���Ƴ�����
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
% �Ƿ񱣴�ͼƬ
if isDraw(7)
    saveas(gca,[resultpath '\' imagename(frame).name] )
    fprintf(fp, '%-20s %-20s %-20s %-20s \r', num2str(frame),num2str(sum(is_match)),num2str(size(targets, 2)), num2str(sum(sum(targets))));
end


pause(0.01)