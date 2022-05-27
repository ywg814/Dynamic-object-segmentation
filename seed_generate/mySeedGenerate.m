%% 种子生成算法
function label = mySeedGenerate(origin, seed_position, label, label_value)
seed_position = fix(seed_position);

threshold = 2;
for i = 1:1:size(seed_position, 1)
    label = calLabel(origin, seed_position(i, :), threshold, label_value, label);
end


function label = calLabel(origin, seed_position, threshold, label_value, label)
global M
global N
seed = origin(seed_position(2), seed_position(1));
% 八邻域判断
xmin = max(seed_position(1) - 1, 1);
xmax = min(seed_position(1) + 1, N);
ymin = max(seed_position(2) - 1, 1);
ymax = min(seed_position(2) + 1, M);

label(seed_position(2),seed_position(1)) = label_value;
new_seed_position = [];
for x = xmin:1:xmax
    for y = ymin:1:ymax
        if abs(origin(y, x)-seed) < threshold && label(y, x) == 0 && 1/(1+1/15*abs(origin(y,x)-seed))>0.8
            label(y, x) = label_value;
            new_seed_position = [new_seed_position;x y];
            
        end
    end
end

while ~isempty(new_seed_position)
    seed_position = new_seed_position(1,:);
    label = calLabel(origin, seed_position, threshold, label_value, label);
    new_seed_position(1,:) = [];
end

