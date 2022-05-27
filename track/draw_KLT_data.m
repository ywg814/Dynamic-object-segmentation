% ¥¶¿ÌKLT∫Ωº£
function draw_KLT_data(frame_info,begin)
bbox = frame_info.target(1,:);
p_first = frame_info.KLT{begin}.points_track;

hold on
v_x = frame_info.KLT_track.v_x;
v_y = frame_info.KLT_track.v_y;
L_x = frame_info.KLT_track.L_x;
L_y = frame_info.KLT_track.L_y;
L_L = frame_info.KLT_track.L_L;
is_target = frame_info.KLT_track.is_target;

figure(4) 
clf()
plot(v_x(~is_target,:)','b')
hold on
plot(v_x(is_target,:)','r')

figure(5)
clf()
hold on
plot(L_L(~is_target,:)','b')
plot(L_L(is_target,:)','r')

