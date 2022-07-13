%% ��ȡ�ٶȳ���Ӧ�Ծ���
function v_sign = calVelocityFiled(frame_info)
targets_clusters = frame_info.targets_clusters(:, end);
index = isinf(targets_clusters);
% index = frame_info.KLT{end}.isFound_allpoints;
% ��ȡ������
dataX = frame_info.L_x(index,end);
dataY = frame_info.L_y(index,end);
position = frame_info.points_track(index,:,end);   %��ȡ���ж�Ϊ�����ĵ�
simulation_plane_data=[position dataX dataY];%[���꣬X�ٶȣ�Y�ٶ�]

field = planeSimulation(simulation_plane_data);%ƽ�����

% ��ȡ���е�
is_match = frame_info.is_match(:,end);
position = frame_info.points_track(is_match,:,end);    % ƥ�䵽�����е�
dataX = frame_info.L_x(is_match,end);
dataY = frame_info.L_y(is_match,end);
judge_plane_data = [position dataX dataY];

v_sign = false(size(is_match));
v_sign(is_match) = isSatisfiePlane(judge_plane_data, simulation_plane_data, field);     %�ж����е��Ƿ�����ƽ�淽��


%%
function field=planeSimulation(plane_data)
% ƽ�����
X = [ones(size(plane_data, 1), 1) plane_data(:,1:2)]; % [wight x, y]
xField = regress(plane_data(:,3),X) ;
% ƽ�淽�̣� velocityX = bx(1) + bx(2)*position(:,1) + bx(3)*position(:,2)
X = [ones(size(plane_data, 1), 1) plane_data(:,1:2)]; % [wight x, y]
yField = regress(plane_data(:,4),X) ;
field = [xField, yField];
% ƽ�淽�̣� velocityX = by(1) + by(2)*position(:,1) + by(3)*position(:,2)
 
%%
function v_sign = isSatisfiePlane(judge_plane_data, plane_data, field)
global parameter
thr = parameter.isSatisfiePlane_thr;
% �ж��˶����Ƿ�����ƽ�淽��
position = judge_plane_data(:,1:2);    % ƥ�䵽�����е�
dataX = judge_plane_data(:,3);
dataY = judge_plane_data(:,4);
std_v = std(plane_data(:,3:4),1);    %�����ٶȳ�����
v_sign = false(size(judge_plane_data, 1),1);

fun = @(x,y,v,b)b(1)+b(2)*x+b(3)*y-v;% ƽ�淽��
for i = 1:1:size(position)
    if abs(fun(position(i,1), position(i,2),dataX(i),field(:,1)))<thr*std_v(1) && abs(fun(position(i,1), position(i,2),dataY(i),field(:,2)))<thr*std_v(2)
        v_sign(i) = true;
    end
end


