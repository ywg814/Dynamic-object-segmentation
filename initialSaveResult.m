%% �洢ʵ����
resultpath = ['E:\Mypaper\��̬Ŀ��ָ�\ʵ����\' imagetitle ];
if ~exist(resultpath)
    mkdir(resultpath)
else
    rmdir(resultpath, 's')
    mkdir(resultpath)
end
fp = fopen([resultpath '\' 'ʵ����.txt'], 'a');
fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', 'frame', 'match points', 'track number','track points number', 'update times');