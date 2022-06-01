%% 存储实验结果
resultpath = ['E:\Mypaper\动态目标分割\实验结果\' imagetitle ];
if ~exist(resultpath)
    mkdir(resultpath)
else
    rmdir(resultpath, 's')
    mkdir(resultpath)
end
fp = fopen([resultpath '\' '实验结果.txt'], 'a');
fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', 'frame', 'match points', 'track number','track points number', 'update times');