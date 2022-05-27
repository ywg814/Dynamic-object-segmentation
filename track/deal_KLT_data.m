
function frame_info = deal_KLT_data(frame_info,frame)
% ����KLT����
% ����frmae_info��Ϣ
points_number = frame_info.points_number;
v_x = nan(points_number,1);
v_y = nan(points_number,1);
L_x = nan(points_number,1);
L_y = nan(points_number,1);
L_L = nan(points_number,1);
L_theta = nan(points_number,1);

is_match = frame_info.is_match(:,frame);
v_temp = frame_info.points_track(:,:,frame) - frame_info.points_track(:,:,frame-1);
v_temp = v_temp(is_match,:);

v_x(is_match) = v_temp(:,1);
v_y(is_match) = v_temp(:,2);
L_temp = frame_info.points_track(:,:,frame)  - frame_info.points_track(:,:,frame_info.refer) ;
L_x(is_match) = L_temp(is_match,1);
L_y(is_match) = L_temp(is_match,2);
L_L(is_match) = sum((L_temp(is_match,:)), 2);

% ����Ƕȣ�
L_theta(is_match) = atand(L_y(is_match)./L_x(is_match));

% ���㼫��Լ��
frame_info = cal_inlierIdx(frame_info,frame);

frame_info.v_x(:,frame) = v_x;
frame_info.v_y(:,frame) = v_y;
frame_info.L_x(:,frame) = L_x;
frame_info.L_y(:,frame) = L_y;
frame_info.L_L(:,frame) = L_L;
frame_info.L_L(:,frame) = L_L + frame_info.L_L(:,frame-1);