%% �ж�Ŀ����Ŀ���Ƿ�ϲ�
function frame_info = integrated_target(frame_info,targets,frame)
% ������࣬�ϲ�������
frame_info = merger_track(frame_info,targets,frame);

% ��������࣬���Ѻ���
frame_info = split_track(frame_info,targets,frame);







