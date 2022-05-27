%% 种子生成算法
function J = seed_generate(origin, seed)
if isinteger(origin)
    origin=im2double(origin);
end
seed = fix(seed);
x1 = seed(1);
y1 = seed(2);
[M, N]=size(origin);
seed=origin(x1, y1);
J=zeros(size(origin));
J(x1,y1)=1;
sum=seed;
suit=1;%点的个数
count=1;
threshold=
0;
while count>0
    s=0;
    count=0;
    for i=1:M
        for j=1:N
            if J(i,j)==1
                if (i-1)>0&&(i+1)<(M+1)&&(j-1)>0&&(j+1)<(N+1)
                    for u=-1:1
                        for v=-1:1
                            if J(i+u,j+v)==0 && abs(origin(i+u,j+v)-seed)<=threshold %&& 1/(1+1/15*abs(origin(i+u,j+v)-seed))>0.8
                                J(i+u,j+v)=1;
                                count=count+1;
                                s=s+origin(i+u,j+v);
                            end
                        end
                    end
                end
            end
        end
    end
    suit=suit+count;
    sum=sum+s;
    seed=sum/suit;
end


