%% 存储实验结果

resultpath = ['E:\Mypaper\动态目标分割\实验结果\' imagetitle '###' datestr(now,'yyyymmdd_HHMMSS')];
mask_path = [resultpath '\mask\'];
fp = [];
if save_result
    
    if ~exist(resultpath)
        mkdir(resultpath)
    else
        rmdir(resultpath, 's')
        mkdir(resultpath)
    end
    
    
    if ~exist(mask_path)
        mkdir(mask_path)
    else
        rmdir(mask_path, 's')
        mkdir(mask_path)
    end
    fp = fopen([resultpath '\' '实验结果.txt'], 'a');
%     fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', 'frame', 'match points', 'track number','track points number', 'update times');
    fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', '1', '0', '0','0', '0');
end
