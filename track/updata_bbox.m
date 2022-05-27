function  [bbox, fea_new,wrong_points,D]= updata_bbox(bbox,fea_new,D,wrong_points)
check = find(isnan(D(:,1)));
D(check,:) = [];
fea_new(check) = [];
num = size(fea_new,2);
for i = 1:1:num
update(i) = fea_new(i).update;
p_num(i) = sum(fea_new(i).sign_cross(:,end));
end
sign_0 = find(update==0);%稳定跟踪点
x = D(sign_0,1);
mean_x = mean(x);
std_x = std(x);
y = D(sign_0,2);
mean_y = mean(y);
std_y = std(y);
xmin = mean_x - 1*std_x;
xmax = mean_x + 1*std_x;
ymin = mean_y - 1*std_y;
ymax = mean_y + 1*std_y;
sign_1 = (sign_0(end)+1):1:num;%待判断点
% wrong_points = [];
for i = size(sign_1,2):-1:1
    x = D(sign_1(i),1);
    y = D(sign_1(i),2);
    sign = fea_new(sign_1(i)).sign_cross(:,end);
    if sum(sign)==0
        D(sign_1(i),:) = [];
        fea_new(sign_1(i)) = [];
        sign_1(i) = [];
        sign_1(i:end) = sign_1(i:end)-1;
        continue
    end
    
    if x<=xmax&&x>=xmin&&y<=ymax&&y>=ymin %在范围以内,结果可信，认为是目标上的特征，update+1，当update大于5帧时，认为稳定更新点，update = 0；
         fea_new(sign_1(i)).update = fea_new(sign_1(i)).update + 1 ;
         if fea_new(sign_1(i)).update>=3
             fea_new(sign_1(i)).update = 0;
             update(sign_1(i)) = 0;
         end
         
        continue
    else
        D(sign_1(i),:) = [];
        wrong_points = [wrong_points;fea_new(sign_1(i)).points];
        fea_new(sign_1(i)) = [];
        update(sign_1(i)) = [];
        sign_1(i) = [];
        sign_1(i:end) = sign_1(i:end)-1;
        
        continue
    end
end
num = size(fea_new,2); 
for i = 1:1:num
    sign = fea_new(i).sign_cross(:,end);
    if sum(sign) == 0
        left(1,i) = nan;
        right(1,i) = nan;
        top(1,i) = nan;
        bottom(1,i) = nan;
    else
        left(1,i) = min(fea_new(i).points(sign ,1));
        right(1,i) = max(fea_new(i).points(sign ,1)); 
        top(1,i) = min(fea_new(i).points(sign ,2));
        bottom(1,i) = max(fea_new(i).points(sign ,2));
    end
end
% bbox选择（1）
left = find(left==min(left));
right = find(right==max(right));
top = find(top==min(top));
bottom = find(bottom==max(bottom));
if isempty(left)
    return
end


xmin = bbox(1)+D(left(1),1);
xmax = bbox(1)+bbox(3)-1+D(right(1),1);
ymin = bbox(2)+D(top(1),2);
ymax = bbox(2)+bbox(4)-1+D(bottom(1),2);

% bbox修改
bbox = bbox + fix([mean(D(:,1)) mean(D(:,2)) 0 0]);
% bbox = [xmin,ymin,xmax-xmin+1,ymax-ymin+1];


%% 跟新模板
num_temp = p_num(sign_0);
for i = size(sign_1,2):-1:1
    if update(sign_1(i)) == 0
    temp = find(num_temp == min(num_temp));
    temp = temp(1);
    fea_new(temp).points = [fea_new(temp).points;fea_new(sign_1(i)).points];
    fea_new(temp).fea_cross = [fea_new(temp).fea_cross;fea_new(sign_1(i)).fea_cross];
%     fea_new(temp).num = fea_new(temp).num + fea_new(sign_1(i)).num;
    fea_new(temp).sign_cross(1:size(fea_new(temp).points,1),end-1:end) = [fea_new(temp).sign_cross(:,end-1:end);fea_new(sign_1(i)).sign_cross(:,end-1:end)];
%     fea_new(temp).pernorm = [fea_new(temp).pernorm;fea_new(sign_1(i)).pernorm];
%     num_temp(temp) = fea_new(temp).num;
%     fea_new(sign_1(i)) = [];
    end
end
for i = size(fea_new,2):-1:1
   
    sign = fea_new(i).sign_cross(:,end);
    fea_new(i).points = fea_new(i).points(sign,:);
    fea_new(i).fea_cross = fea_new(i).fea_cross(sign,:);
    fea_new(i).sign_cross = fea_new(i).sign_cross(sign);
end
% xmin = bbox(1) + min(D(:,1));
% xmax = bbox(1) + max(D(:,1)) + bbox(3) - 1;
% ymin = bbox(2) + min(D(:,2));
% ymax = bbox(2) + max(D(:,2)) + bbox(4) - 1;
% bbox = [xmin,ymin,xmax-xmin+1,ymax-ymin+1];
