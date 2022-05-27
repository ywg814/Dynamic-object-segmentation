%% 种子生成算法例子
clear
clc
close all
global M
global N

origin = zeros(1024,1024);
origin(200:256,169:356) = 255;
origin(300:356,469:656) = 255;
seed_position = [200 236;586 336];
[M, N] = size(origin);
target = mySeedGenerate(origin, seed_position);
imshow(target,[])