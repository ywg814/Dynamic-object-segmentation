function fea = updata(fea,fea_new,srcimg,bbox)
[M,N] = size(srcimg);
lamd = 0.9;
points = [];
for i = 1:1:size(fea_new,2)
points = [points;fea_new(i).points];
end
xmin = bbox(1);
xmax = bbox(1)+bbox(3)-1;
ymin = bbox(2);
ymax = bbox(2)+bbox(4)-1;
points = points - repmat([xmin ymin],size(points,1),1)+1;
target = srcimg(ymin:ymax,xmin:xmax);
ed = edge(target, 'canny', 0.1);
boundary = double(ed);
[m,n] = size(target); 
temp = zeros(m,n);
temp(sub2ind(size(temp), points(:,2), points(:,1))) = 1;
[temp_points(:,2),temp_points(:,1)] = find(boundary==1);
figure(3)
clf
subplot(1,2,1)
imshow(target,[]);
subplot(1,2,2)
hold on
imshow(boundary,[])
scatter(points(:,1),points(:,2))
hold off
for i = 1:1:size(temp_points,1)
    x = temp_points(i,1);
    y = temp_points(i,2);
    xmin = max(x-1,1);
    xmax = min(x+1,n);
    ymin = max(y-1,1);
    ymax = min(y+1,m);
    if sum(sum(temp(ymin:ymax,xmin:xmax))) == 0
        boundary(y,x) = 0;
    end
end
curve = [];
fea = make_rec2(target,curve,boundary,bbox);
% points2 = points2 + repmat([xmin ymin],k-1,1)-1;
% [fea,~] = fea_value(points2,srcimg,[1,1,N,M]);

