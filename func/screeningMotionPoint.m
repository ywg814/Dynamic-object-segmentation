%%  �ж�Ŀ����Ƿ������ٶȳ�ƽ�棬�����ٶȳ�ƽ��ĵ㲻��Ϊ���˶���
function frame_info = screeningMotionPoint(frame_info,frame)
v_sign = calVelocityFiled(frame_info);
frame_info.v_sign(:,frame) = v_sign;

background = frame_info.background;
target = frame_info.target;
sus_target = frame_info.sus_target;

background(:,end) = background(:,end) | v_sign;
target(v_sign, end) = false;
sus_target(v_sign, end) = false;

frame_info.background = background;
frame_info.target = target;
frame_info.sus_target = sus_target;