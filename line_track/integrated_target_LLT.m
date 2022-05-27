%% 判断目标数目，是否合并
function frame_info = integrated_target_LLT(frame_info,targets,frame)

cc = sum(targets,1);
if sum(cc == 0)>0
    1
end

% targets = double(targets);
origin = frame_info.LLT_track.targets;
origin_num = size(origin,2);
new_num = size(targets,2);
if isempty(origin)
    frame_info.LLT_track.targets = double(targets);
    frame_info.LLT_track.relevance = frame*ones(new_num);
    frame_info.LLT_track.relevance_begin = frame*ones(new_num);
    return
end

relevance_begin = frame_info.LLT_track.relevance_begin;
relevance = zeros(origin_num);
o_relevance = frame_info.LLT_track.relevance;
relevance(1:origin_num,1:origin_num) = o_relevance;
l_r = false(size(relevance));

for i = 1:1:new_num
    % 计算各目标的相关性
    temp = zeros(1,origin_num);
     for j = 1:1:origin_num
            temp(j) = sum(logical(origin(:,j)) & targets(:,i));
     end
     t = find(temp~=0);
     l_r(sub2ind(size(l_r),t,t)) = true;
     for m = 1:1:size(t,2)
         for n = m+1:1:size(t,2)
             relevance(t(m),t(n)) = relevance(t(m),t(n)) + 1;
         end
     end
%      relevance(t,t) = relevance(t,t) + 1;
    
     
    while sum(targets(:,i))>0
        for j = 1:1:origin_num
            temp(j) = sum(logical(origin(:,j)) & targets(:,i));
        end
        all = sum(targets(:,i));
        s = find(temp == max(max(temp),1));
        if ~isempty(s)
            s = s(1);
            sign = logical(origin(:,s)) & targets(:,i);
            origin(sign,s) = origin(sign,s) + double(targets(sign,i));    % 合并原先目标
            targets(sign,i) = false;
            
            if sum(origin(:,s)) == 0
                1;
            end
            
            continue
            
        elseif isempty(s)
            if sum(targets(:,i)) == 0
                1;
            end
            origin(:,end+1) = double(targets(:,i));        %新的目标
            targets(:,i) = false;
            relevance(end+1,end+1) = frame;
            l_r(end+1,end+1) = false;
            relevance_begin(end+1,end+1) = frame;
            break;
        else
            % 交汇多个目标合并
            
        end
    end
    
end
relevance(l_r)= relevance(l_r)+1;

% 剔除不在更新的航迹以及空航迹
temp = sum(origin,1);
index = (temp == 0);
temp = diag(relevance);
temp = frame - temp';
index2 = (temp>5);
index = index | index2;



origin(:,index) = [];
relevance(:,index) = [];
relevance(index,:) = [];
relevance_begin(:,index) = [];
relevance_begin(index,:) = [];

% 关联性强，合并航迹
for i = 1:1:size(origin,2)
    temp = [];
    for j = i+1:1:size(origin,2)
        if relevance(i,j)>5 &&relevance(j,j) - relevance_begin(j,j)<30  % 5帧以上相关联，航迹单独存在不超过20帧
            temp = [temp j];
        end
    end
    
    for j = size(temp,2):-1:1
        origin(:,i) = origin(:,i) + origin(:,temp(j));
        origin(:,temp(j)) = [];
        relevance(:,temp(j)) = [];
        relevance(temp(j),:) = [];
        relevance_begin(:,temp(j)) = [];
        relevance_begin(temp(j),:) = [];
    end
end

frame_info.LLT_track.targets = origin;
frame_info.LLT_track.relevance = relevance;
frame_info.LLT_track.relevance_begin = relevance_begin;
cc = sum(origin,1);
if sum(cc == 0)>0
    1
end