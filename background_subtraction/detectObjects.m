% function [centroids, bboxes, mask] = detectObjects(frame)
% This function is to dectect moving object
% Inputs:
%           frame:              frame
% Outputs:
%           centroids:          array
%           bboxes:             array
%           mask:               array-
function [mask, origin, original_composition] = detectObjects(frame_refer, image_frame, origin, original_composition, frame_info, frame)
global parameter
back_thr = parameter.back_thr;
L = parameter.L;

targets = frame_info.targets{end};
targets_numbers = size(targets, 2);    %当前帧检测到的目标点数目

%% 重构图像
tform = frame_info.tform;
H = eye(3);
for i = frame_refer:1:size(tform, 3)
    H = H * tform(:,:, i);
end

agt = vision.GeometricTransformer;
Ir = step(agt, origin, inv(H));
Ir(isnan(Ir)) = 0;
mask_temp = abs(Ir - image_frame);

mask_temp1 = false(size(image_frame));

mask_temp1(mask_temp>back_thr) = true;
mask_temp = mask_temp1;
mask_temp = mask_temp & logical(Ir);    %避免重构的视差部分影响检测
mask = false(size(mask_temp));
for targer_number = 1:1:targets_numbers    %对目标进行定位
    points_track = frame_info.points_track(:,:,end) ;
    points = points_track(logical(targets(:,targer_number)),:);
    points = fix(points);
    % points包含的所有点都记为种子点
    xmin = min(points(:, 1));
    xmax = max(points(:, 1));
    X = xmin:1:xmax;
    ymin = min(points(:, 2));
    ymax = max(points(:, 2));
    Y = ymin:1:ymax;
    [m, n] = meshgrid(X,Y);
    res = [];
    [res(:,1),res(:,2) ] = deal( reshape(m,[],1), reshape(n,[],1) );
    points = res;
    %生成区域
    mask = connection8(mask_temp, mask, points, L);
    
    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [3,3]));
    mask = imclose(mask, strel('rectangle', [15, 15]));
    mask = imfill(mask, 'holes');
end
% 更新背景图像
[origin, original_composition]= updateOrigin(origin, mask, image_frame, H, agt, original_composition, frame);
end

function mask = connection8(mask_temp, mask, points, L)

seed = points;
[M, N] = size(mask);
mask_count = true(M, N);
while ~isempty(seed)
    x = seed(1, 1);
    y = seed(1, 2);
    seed(1,:) = [];
    if x == 0 || y == 0
        continue
    end
    mask_temp(y, x) = false;
    mask_count(y, x) = false;
    for i = 1:1:size(L, 1)
        delta_L(i) = norm(([x,y] - points(i,:)), 2);
    end
    if min(delta_L) > L    %与种子点的最小距离都小于L
        continue;
    end
    
    if x<2 || y< 2 || M-y<2 || N-x <2
        continue
    end
    
    mask(y, x) = true;
    
    if  mask_temp(y-1, x-1) && mask_count(y-1, x-1)
        seed = [seed;x-1, y-1];
        mask_count(y-1, x-1) = false;
    end
    if  mask_temp(y-1, x) && mask_count(y-1, x)
        seed = [seed;x, y-1];
        mask_count(y-1, x) = false;
    end
    if  mask_temp(y-1, x+1) && mask_count(y-1, x+1)
        seed = [seed;x+1, y-1];
        mask_count(y-1, x+1) = false;
    end
    if  mask_temp(y, x-1) && mask_count(y, x-1)
        seed = [seed;x-1, y];
        mask_count(y, x-1) = false;
    end
    if  mask_temp(y, x+1) && mask_count(y, x+1)
        seed = [seed;x+1, y];
        mask_count(y, x+1) = false;
    end
    if  mask_temp(y+1, x-1) && mask_count(y+1, x-1)
        seed = [seed;x-1, y+1];
        mask_count(y+1, x-1) = false;
    end
    if  mask_temp(y+1, x) && mask_count(y+1, x)
        seed = [seed;x, y+1];
        mask_count(y+1, x) = false;
    end
    if  mask_temp(y+1, x+1) && mask_count(y+1, x+1)
        seed = [seed;x+1, y+1];
        mask_count(y+1, x+1) = false;
    end
end

end

function [origin, original_composition]= updateOrigin(origin, mask, image_frame, H, agt, original_composition, frame)
% 更新背景图像
global parameter
r = parameter.r;
[M, N] = size(origin);
Ir = step(agt, image_frame, H);   %当前帧投影为参考帧
mask_Ir = logical(step(agt, double(mask), H));
% if frame < 5
original_temp = zeros(M, N);
original_temp(~mask_Ir ) = Ir(~mask_Ir );
original_composition(:,:,end + 1) = original_temp;
% else
%     for i = 2:1:3
%         original_composition(:,:,i) = original_composition(:,:,i + 1);
%     end
%     original_composition(:,:,4) = Ir;
% end
for m = 1:1:M
    for n = 1:1:N
        if mask_Ir(m, n) && Ir(m, n)
            %             origin(m, n) = r*origin(m, n) + (1-r)*mean(original_composition(m, n, 2:end));
            data = original_composition(m, n, 1:end);
            data = data(:);
            data(data==0) = [];
            origin(m, n) = mean(filloutliers(data,'nearest','gesd'));
        end
    end
end
original_composition(:,:,1) = origin;

if 1
    figure(3)
    imshow(original_composition(:,:,1), []);
    
end
end
