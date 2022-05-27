%% meanshift
function Idx = MeanShift_f(data,radius)
[m,~]=size(data);
index=1:m;

stopthresh=1e-3*radius;
visitflag=zeros(m,1);%标记是否被访问
count=[];
clustern=0;
clustercenter=[];

while ~isempty(index)
    cn=ceil((length(index)-1e-6)*rand);%随机选择一个未被标记的点，作为圆心，进行均值漂移迭代
    center=data(index(cn),:);
    this_class=zeros(m,1);%统计漂移过程中，每个点的访问频率
    
    
    %步骤2、3、4、5
    end_loop = 1;
    while end_loop<30
        end_loop = end_loop + 1;
        %计算球半径内的点集
        dis=sum((repmat(center,m,1)-data).^2,2);
        radius2=radius*radius;
        innerS=find(dis<=radius*radius);
        visitflag(innerS)=1;%在均值漂移过程中，记录已经被访问过得点
        this_class(innerS)=this_class(innerS)+1;
        %根据漂移公式，计算新的圆心位置
        newcenter=zeros(1,2);
       % newcenter= mean(data(innerS,:),1); 
        sumweight=0;
        for i=1:length(innerS)
            w=exp(dis(innerS(i))/(radius*radius));
            sumweight=w+sumweight;
            newcenter=newcenter+w*data(innerS(i),:);
        end
        newcenter=newcenter./sumweight;

        if norm(newcenter-center) <stopthresh || isnan(norm(newcenter-center))%计算漂移距离，如果漂移距离小于阈值，那么停止漂移
            break;
        end
        center=newcenter;
%         plot(center(1),center(2),'*y');
    end
    %步骤6 判断是否需要合并，如果不需要则增加聚类个数1个
    mergewith=0;
    for i=1:clustern
        betw=norm(center-clustercenter(i,:));
        if betw<radius/2
            mergewith=i; 
            break;
        end
    end
    if mergewith==0           %不需要合并
        clustern=clustern+1;
        clustercenter(clustern,:)=center;
        count(:,clustern)=this_class;
    else                      %合并
        clustercenter(mergewith,:)=0.5*(clustercenter(mergewith,:)+center);
        count(:,mergewith)=count(:,mergewith)+this_class;  
    end
    %重新统计未被访问过的点
    index=find(visitflag==0);
end%结束所有数据点访问

%绘制分类结果
for i=1:m
    [value, index]=max(count(i,:));
    Idx(i)=index;
end
