function [fea,wrong_points]= updata3(fea,srcimg,bbox,wrong_points)
back_points = [];
[M,N] = size(srcimg);
lamd = 0.9;
points = [];
xmin = bbox(1);
xmax = bbox(1)+bbox(3)-1; 
ymin = bbox(2);
ymax = bbox(2)+bbox(4)-1;
target = srcimg(ymin:ymax,xmin:xmax);
ed = edge(target, 'canny', 0.1);
boundary = double(ed);
[m,n] = size(target);
new = zeros(m,n);
for i = 1:1:size(fea,2)
    temp = zeros(m,n);
    points2 = [fea(i).points];
    sign = fea(i).sign_cross(:,end);
    if sum(sign)==0
        continue
    end
    points2(sign,:) = points2(sign,:) - repmat([xmin ymin],sum(sign),1)+1;
    b1 = boundary;
    sign2 = zeros(size(points2,1),1);
    p2 = [];
    [new,sign,sign2,p2] = cal_new(new,b1,points2,sign,sign2,p2);
    [new,sign,sign2,p2] = cal_new(new,b1,points2,sign,sign2,p2);%% 靠近
    
    %% 对现有点进行更新
    sign2 = logical(sign2);
    [fea_temp,sign3] =  fea_value(p2(sign2,:),target,[1,1,n,m]);
    if sign3 == 0
        fea(i).sign(:,end) = 0;
        continue
    end
    fea_temp.points = fea_temp.points + repmat([xmin ymin],sum(sign2),1)-1;
    fea(i).points(sign,:) = fea_temp.points;
    fea(i).fea_cross(sign,:) = fea_temp.fea_cross;
    sign(sign2,:) = fea_temp.sign_cross;
    fea(i).sign_cross(:,end) = sign;
    
end
% fea = fea;
%% 加入新的点
if ~isempty(wrong_points )
    wrong_points = wrong_points - repmat([xmin ymin],size(wrong_points,1),1)+1;
    [m,n] = size(b1);
    for i  = 1:1:size(wrong_points,1)
        x = wrong_points(i,1);
        y = wrong_points(i,2);
        
        if x>0&&x<n&&y>0&&y<m
            b1(wrong_points(i,2),wrong_points(i,1)) = 0;
        end
    end
end
fea_new = select_new(fea,target,b1,bbox);
if isempty(fea_new)
    fea = fea;
else
    fea = [fea fea_new];
end


xmin = bbox(1);
xmax = bbox(1)+bbox(3)-1;

ymin = bbox(2);
ymax = bbox(2)+bbox(4)-1;
w = bbox(3);
h = bbox(4);
xback_min = fix(max(xmin - 1/2*w,1));
xback_max = fix(min(xmax + 1/2*w,N));
yback_min = fix(max(ymin - 1/2*h,1));
yback_max = fix(min(ymax + 1/2*h,M));
back(yback_min:yback_max,xback_min:xback_max) = srcimg (yback_min:yback_max,xback_min:xback_max);
back(ymin:ymax,xmin:xmax) = 0;
bbox = [xback_min yback_min xback_max-xback_min+1 yback_max-yback_min+1];
fea2 = cal_fea2(back,bbox,5);
wrong_points1 = wrong_points;
if ~isempty(wrong_points )
    wrong_points1 = wrong_points + repmat([xmin ymin],size(wrong_points,1),1)-1;
    for i = size(wrong_points1,1):-1:1
        if wrong_points1(i,1)<xmin||wrong_points1(i,1)>xmax||wrong_points1(i,2)<ymin||wrong_points1(i,2)>ymax
            wrong_points1(i,:) = [];
        end
    end
end
wrong_points2 = [];
for i = 1:1:size(fea2,2)
    wrong_points2 = [wrong_points2;fea2(i).points];
end
for i = size(wrong_points2,1):-1:1
    if wrong_points2(i,1)<xback_min||wrong_points2(i,1)>xback_max||wrong_points2(i,2)<yback_min||wrong_points2(i,2)>yback_max||(wrong_points2(i,1)>=xmin&&wrong_points2(i,1)<=xmax&&wrong_points2(i,2)>=ymin&&wrong_points2(i,2)<=ymax)
        wrong_points2(i,:) = [];
    end
end
wrong_points = [wrong_points1;];




function [new,sign,sign2,p2] = cal_new(new,b1,points2,sign,sign2,p2)
B=[0 1 0
    1 1 1
    0 1 0];
b1 = imdilate(b1,B);
[m,n] = size(b1);
for j = 1:1:size(points2,1)
    if sign(j,1)==0
        continue
    end
    x = points2(j,1);
    y = points2(j,2);
    if x<2||y<2||x>n-2||y>m-2
        sign(j,1)=0;
        p2(j,:) = [0 0];
        sign2(j,1)=0;
        continue
    end

    if sign2(j,1) == 1
        continue
    end
    if sign2(j,1) == 0&&b1(y,x) == 1&&new(y,x)~=1%
        new(y,x) = 1;
        sign2(j,1) = j;
        p2(j,:) = [x,y];
    end
    if sign2(j,1) == 0&&b1(y-1,x) == 1&&new(y-1,x)==0%
        y2 = y-1;
        x2 = x;
        new_sign;
    end
    if sign2(j,1) == 0&&b1(y+1,x) == 1&&new(y+1,x)==0%
        y2 = y+1;
        x2 = x;
        new_sign;
    end
    if sign2(j,1) == 0&&b1(y,x-1) == 1&&new(y,x-1)==0%
        y2 = y;
        x2 = x-1;
        new_sign;
    end
    if sign2(j,1) == 0&&b1(y,x+1) == 1&&new(y,x+1)==0%
        y2 = y;
        x2 = x+1;
        new_sign;
    end
    if sign2(j,1) == 0&& b1(y-1,x-1) == 1&&new(y-1,x-1)==0%
        y2 = y-1;
        x2 = x-1;
        new_sign;
    end
    if sign2(j,1) == 0&& b1(y-1,x+1) == 1&&new(y-1,x+1)==0%
        y2 = y-1;
        x2 = x+1;
        new_sign;
    end
    if sign2(j,1) == 0&&b1(y+1,x-1) == 1&&new(y+1,x-1)~=1%
        y2 = y+1;
        x2 = x-1;
        new_sign;
    end
    if sign2(j,1) == 0&& b1(y+1,x+1) == 1&&new(y+1,x+1)~=1%
        y2 = y+1;
        x2 = x+1;
        new_sign;
    end
    if sign2(j,1) == 0
        p2(j,:) = [0,0];
        sign(j,1) = 0;
    end
end

function fea2 = select_new(fea,target,b1,bbox)
xmin = bbox(1);
xmax = bbox(1)+bbox(3)-1;
ymin = bbox(2);
ymax = bbox(2)+bbox(4)-1;
[m,n] = size(b1);
b1(1:5,:) = 0;
b1(end-4:end,:) = 0;
b1(:,1:5) = 0;
b1(:,end-4:end) = 0;
for i = 1:1:size(fea,2)
    sign = fea(i).sign_cross(:,end);
    points = fea(i).points(sign,:);
    points = points - repmat([xmin ymin],size(points,1),1)+1;
    num = size(points,1);
    for j = 1:1:num
        x1 = points(j,1)-1;
        x2 = points(j,1)+1;
        y1 = points(j,2)-1;
        y2 = points(j,2)+1;
        x1 = max(x1,1);x2 = min(x2,n);y1 = max(y1,1);y2 = min(y2,m);
        b1(y1:y2,x1:x2) = 0;
    end
end
% [p_new(:,2),p_new(:,1)] = find(b1==1);
% [curve,boundary] = deal_target(b1,5);
% fea = [];
fea2 = make_rec2(target,b1,bbox);
for i = size(fea2,2):-1:1
    sign = fea2(i).sign_cross;
    if sum(sign)==0
        fea2(i) = [];
        continue
    end
    fea2(i).update = 1;
end


