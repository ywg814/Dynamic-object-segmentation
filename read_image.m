%% ¶ÁÍ¼Ïñ

function I = read_image(image_path)

I= imread(image_path);
% I = double(I);
if size(I,3) == 3
        I = rgb2gray(I);
    else
        I = I;       
    end
