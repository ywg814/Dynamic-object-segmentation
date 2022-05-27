%% �ϲ�����
function frame_info = merger_track(frame_info,targets,frame)
% targets = double(targets);
origin = frame_info.targets{frame-1};
origin_num = size(origin,2);
new_num = size(targets,2);
if isempty(origin)
    frame_info.targets{frame} = double(targets);
    frame_info.relevance{frame} = frame*eye(new_num);
    frame_info.relevance_begin{frame} = frame*eye(new_num);
    return
end

relevance_begin = frame_info.relevance_begin{frame-1};  %�������ֵ���ʼ֡
relevance = zeros(origin_num);                           %��ǰ֡�ĺ��������
o_relevance = frame_info.relevance{frame-1};
relevance(1:origin_num,1:origin_num) = o_relevance;
l_r = false(size(relevance));

for i = 1:1:new_num
    % �����Ŀ��������
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
    
    while sum(targets(:,i))>0
        for j = 1:1:origin_num
            temp(j) = sum(logical(origin(:,j)) & targets(:,i));
        end
        all = sum(targets(:,i));
        s = find(temp == max(max(temp),1));
        if ~isempty(s)
            s = s(1);
            sign = logical(origin(:,s)) & targets(:,i);
            origin(sign,s) = origin(sign,s) + double(targets(sign,i));    % �ϲ�ԭ��Ŀ��
            targets(sign,i) = false;
            if sum(origin(:,s)) == 0
                1;
            end
            
            continue
            
        elseif isempty(s)
            if sum(targets(:,i)) == 0
                1;
            end
            origin(:,end+1) = double(targets(:,i));        %�µ�Ŀ��
            targets(:,i) = false;
            relevance(end+1,end+1) = frame;
            l_r(end+1,end+1) = false;
            relevance_begin(end+1,end+1) = frame;
            break;
        else
            % ������Ŀ��ϲ�
            
        end
    end
    
end
relevance(l_r)= relevance(l_r)+1;

% �޳����ڸ��µĺ����Լ��պ���
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

% ������ǿ���ϲ�����
for i = 1:1:size(origin,2)
    temp = [];
    for j = i+1:1:size(origin,2)
        %         if relevance(i,j)>5 &&relevance(j,j) - relevance_begin(j,j)<30  % 5֡����������������������ڲ�����20֡
        if relevance(i,j)>3  % 5֡���������
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

frame_info.targets{frame} = origin;
frame_info.relevance{frame} = relevance;
frame_info.relevance_begin{frame} = relevance_begin;