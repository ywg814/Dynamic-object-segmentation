function frame_info = split_track(frame_info,targets,frame)
origin = frame_info.targets{frame};
new_num = size(targets,2);
relevance = frame_info.relevance{frame};
relevance_begin = frame_info.relevance_begin{frame};


num = size(origin,2);
for i = 1:1:num
    temp = zeros(1,new_num);
    for j = 1:1:new_num
        temp(j) = sum(logical(origin(:,i)) & targets(:,j));
    end
    t = find(temp~=0);
    if size(t,2)>1   %航迹被分裂为size(t,2)份
        track_temp = false(size(origin,1),size(t,2));
        for j = 1:1:size(t,2)
            track_temp(:,j) = logical(origin(:,i)) & targets(:,t(j));
        end
        origin(:,i) = track_temp(:,1);
        origin(:,end+1:end+size(t,2)-1) = track_temp(:,2:end);
        relevance(end+1:end+size(t,2)-1,end+1:end+size(t,2)-1) = frame*eye(size(t,2)-1);
        relevance_begin(end+1:end+size(t,2)-1,end+1:end+size(t,2)-1) = frame*eye(size(t,2)-1);
        
        
    end
end

frame_info.targets{frame} = origin;
frame_info.relevance{frame} = relevance;
frame_info.relevance_begin{frame} = relevance_begin;