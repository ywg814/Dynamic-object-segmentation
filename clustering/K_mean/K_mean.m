function sign = K_mean(X,num)  %�������������
opts = statset('Display','final');

[Idx,Ctrs,SumD,D] = kmeans(X,num,'Replicates',3,'Options',opts);
sign = false(size(X,1),num);
for i = 1:1:num
    sign(Idx==num,i) = true;
end

end
% ��������������������������������
% ��Ȩ����������ΪCSDN������Norstc����ԭ�����£���ѭCC 4.0 BY-SA��ȨЭ�飬ת���븽��ԭ�ĳ������Ӽ���������
% ԭ�����ӣ�https://blog.csdn.net/a493823882/article/details/79282425