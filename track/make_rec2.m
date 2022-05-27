function fea = make_rec2(target,boundary,bbox)

[L,num_L] = bwlabel(boundary,8);
if num_L==0
    fea = [];
end
k = 0;
for i = 1:1:num_L
    [Y,X] = find(L==i);
    if size(Y,1)<5||(max(X)-min(X))>0.3*bbox(3)||(max(Y)-min(Y))>0.3*bbox(4)
        continue
    end
    k = k+1;
    col_p{k} = [X Y];
    
end
i_temp = 0;
for i = 1:1:k
    p = col_p{i};
    sign = true(size(p,1),1);
    [fea_temp,sign,sign2] =  fea_value(p,target,sign,bbox);
    if sign2 == 0
        continue
    end
    i_temp = i_temp + 1;
    fea(i_temp)= fea_temp;

    
end
if ~exist('fea')
    fea = [];
end



