%�����ڸ���ʱ����Ŀ��㲻�жϷ���
function frame_info = ifUpdate(frame_info, update_target, frame_delta)
if frame_delta > 5
    return
else
    frame_info.target(:,end) = frame_info.target(:,end) | update_target;
    frame_info.background(:,end) = frame_info.background(:,end) & ~update_target;
end