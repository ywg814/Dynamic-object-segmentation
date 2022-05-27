function sign = K_mean(X,num)  %样本数与聚类数
opts = statset('Display','final');

[Idx,Ctrs,SumD,D] = kmeans(X,num,'Replicates',3,'Options',opts);
sign = false(size(X,1),num);
for i = 1:1:num
    sign(Idx==num,i) = true;
end

end
% ————————————————
% 版权声明：本文为CSDN博主「Norstc」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
% 原文链接：https://blog.csdn.net/a493823882/article/details/79282425