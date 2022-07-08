%% 提取速度场单应性矩阵
function v_sign = calVelocityFiled(frame_info)
index = frame_info.background(:, end);
% index = frame_info.KLT{end}.isFound_allpoints;
% 提取背景点
dataX = frame_info.L_x(index,end);
dataY = frame_info.L_y(index,end);
position = frame_info.points_track(index,:,end);   %提取已判定为背景的点
simulation_plane_data=[position dataX dataY];%[坐标，X速度，Y速度]

field = planeSimulation(simulation_plane_data);%平面仿真

% 提取所有点
is_match = frame_info.is_match(:,end);
position = frame_info.points_track(is_match,:,end);    % 匹配到的所有点
dataX = frame_info.L_x(is_match,end);
dataY = frame_info.L_y(is_match,end);
judge_plane_data = [position dataX dataY];

v_sign = false(size(is_match));
v_sign(is_match) = isSatisfiePlane(judge_plane_data, simulation_plane_data, field);     %判断所有点是否满足平面方程


%%
function field=planeSimulation(plane_data)
% 平面仿真
X = [ones(size(plane_data, 1), 1) plane_data(:,1:2)]; % [wight x, y]
xField = regress(plane_data(:,3),X) ;
% 平面方程： velocityX = bx(1) + bx(2)*position(:,1) + bx(3)*position(:,2)
X = [ones(size(plane_data, 1), 1) plane_data(:,1:2)]; % [wight x, y]
yField = regress(plane_data(:,4),X) ;
field = [xField, yField];
% 平面方程： velocityX = by(1) + by(2)*position(:,1) + by(3)*position(:,2)
 
%%
function v_sign = isSatisfiePlane(judge_plane_data, plane_data, field)
global parameter
thr = parameter.isSatisfiePlane_thr;
% 判断运动场是否满足平面方程
position = judge_plane_data(:,1:2);    % 匹配到的所有点
dataX = judge_plane_data(:,3);
dataY = judge_plane_data(:,4);
std_v = std(plane_data(:,3:4),1);    %背景速度场方差
v_sign = false(size(judge_plane_data, 1),1);

fun = @(x,y,v,b)b(1)+b(2)*x+b(3)*y-v;% 平面方程
for i = 1:1:size(position)
    if abs(fun(position(i,1), position(i,2),dataX(i),field(:,1)))<thr*std_v(1) && abs(fun(position(i,1), position(i,2),dataY(i),field(:,2)))<thr*std_v(2)
        v_sign(i) = true;
    end
end


