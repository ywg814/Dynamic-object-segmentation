%% meanshift
function Idx = MeanShift_f(data,radius)
[m,~]=size(data);
index=1:m;

stopthresh=1e-3*radius;
visitflag=zeros(m,1);%����Ƿ񱻷���
count=[];
clustern=0;
clustercenter=[];

while ~isempty(index)
    cn=ceil((length(index)-1e-6)*rand);%���ѡ��һ��δ����ǵĵ㣬��ΪԲ�ģ����о�ֵƯ�Ƶ���
    center=data(index(cn),:);
    this_class=zeros(m,1);%ͳ��Ư�ƹ����У�ÿ����ķ���Ƶ��
    
    
    %����2��3��4��5
    end_loop = 1;
    while end_loop<30
        end_loop = end_loop + 1;
        %������뾶�ڵĵ㼯
        dis=sum((repmat(center,m,1)-data).^2,2);
        radius2=radius*radius;
        innerS=find(dis<=radius*radius);
        visitflag(innerS)=1;%�ھ�ֵƯ�ƹ����У���¼�Ѿ������ʹ��õ�
        this_class(innerS)=this_class(innerS)+1;
        %����Ư�ƹ�ʽ�������µ�Բ��λ��
        newcenter=zeros(1,2);
       % newcenter= mean(data(innerS,:),1); 
        sumweight=0;
        for i=1:length(innerS)
            w=exp(dis(innerS(i))/(radius*radius));
            sumweight=w+sumweight;
            newcenter=newcenter+w*data(innerS(i),:);
        end
        newcenter=newcenter./sumweight;

        if norm(newcenter-center) <stopthresh || isnan(norm(newcenter-center))%����Ư�ƾ��룬���Ư�ƾ���С����ֵ����ôֹͣƯ��
            break;
        end
        center=newcenter;
%         plot(center(1),center(2),'*y');
    end
    %����6 �ж��Ƿ���Ҫ�ϲ����������Ҫ�����Ӿ������1��
    mergewith=0;
    for i=1:clustern
        betw=norm(center-clustercenter(i,:));
        if betw<radius/2
            mergewith=i; 
            break;
        end
    end
    if mergewith==0           %����Ҫ�ϲ�
        clustern=clustern+1;
        clustercenter(clustern,:)=center;
        count(:,clustern)=this_class;
    else                      %�ϲ�
        clustercenter(mergewith,:)=0.5*(clustercenter(mergewith,:)+center);
        count(:,mergewith)=count(:,mergewith)+this_class;  
    end
    %����ͳ��δ�����ʹ��ĵ�
    index=find(visitflag==0);
end%�����������ݵ����

%���Ʒ�����
for i=1:m
    [value, index]=max(count(i,:));
    Idx(i)=index;
end
