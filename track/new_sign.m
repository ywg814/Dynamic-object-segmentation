if j == 1
    new(y2,x2) = 1;
    sign2(j,1) = 1;
    p2(j,:) = [x2,y2];
end
if sum(sum(new(y2-1:y2+1,x2-1:x2+1))) >0
    new(y2,x2) = 1;
    sign2(j,1) = 1;
    p2(j,:) = [x2,y2];
end