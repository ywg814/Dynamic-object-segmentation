%% 读写数据
clear
clc
fp = fopen(['实验结果.txt'], 'w');
% fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', 'frame', 'match points', 'track number','track points number', 'update times');
fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', num2str(1),num2str(15),num2str(3), num2str(7), num2str(6));
fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', num2str(1),num2str(5),num2str(3), num2str(71), num2str(6));
fprintf(fp, '%-20s %-20s %-20s %-20s %-20s \r', num2str(51),num2str(5),num2str(3), num2str(7), num2str(6));
fclose(fp); %关闭文件
fp = fopen(['实验结果.txt'], 'r');
data = fscanf(fp, '%f %f %f %f %f', [5 inf]);
data = data';
fclose(fp); %关闭文件