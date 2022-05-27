%% SIFT特征提取
%% 图像的线检测
clear
clc
close all
warning off


imagetitle = 'egtest02';
param
% 图像参数
frame_info = [];
frame_info.target = p_true;
% nz	= strcat('%0',num2str(numzeros),'d');
begin = 1;
frame = begin;
Iin = read_image([imagepath sprintf(strcat('%0',num2str(numzeros),'d'),frame) fext]);
I1 = double(Iin);
[M,N] = size(I1);
scale = 4;
I{1} = imresize(I1,2);
for s = 2:1:scale
    I{s} = impyramid(I{s-1}, 'reduce');
end



sigma = 5;
for s = 1:1:scale
    for i = 1:1:5
        sigma_temp = 2^(i-1)*(sigma*(2^(1/s))^i-1);
        w=fspecial('gaussian',[5 5],i*sigma);
        L{s}(:,:,i) =imfilter(I{s},w);
%         figure
%         imshow(L{s}(:,:,i),[])
        D{s}(:,:,i) = L{s}(:,:,i) - L{s}(:,:,1);
    end
end



% sigma = 15;
% %%
% for i = 1:1:M
%     for j = 1:1:N
%         G(i,j) = 1/(2*pi*sigma^2)*exp(-(i^2+j^2)/(2*sigma^2));
%     end
% end
% mesh(G)