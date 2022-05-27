%%
function draw_E(frame_info,Iin,Iout,frame,pin,pout)


if nargin<5
    d = frame_info.FundamentalMatrix{frame,1}.d;
    pin = frame_info.SURFF_pin{frame};
    pout = frame_info.SURFF_pout{frame};
    inlierIdx = frame_info.FundamentalMatrix{frame,1}.inlierIdx;
    figure(1)
    clf()
    subplot(1,2,1)
    imshow(Iin,[])
    hold on
    scatter(pin(inlierIdx,1),pin(inlierIdx,2),'r')
    scatter(pin(~inlierIdx,1),pin(~inlierIdx,2),'b')
    subplot(1,2,2)
    imshow(Iout,[])
    hold on
    scatter(pout(inlierIdx,1),pout(inlierIdx,2),'r')
    scatter(pout(~inlierIdx,1),pout(~inlierIdx,2),'b')
    legend('满足极线约束','不满足极线约束')
    v = frame_info.SURFF_v{frame};
else
    d = computeDistance( pin, pout, frame_info.FundamentalMatrix{frame,1}.E);
    inlierIdx = true(size(pin,1),1);
    inlierIdx(d>2*mean(d)) = false;
    figure(1)
    clf()
    subplot(1,2,1)
    imshow(Iin,[])
    hold on
    scatter(pin(inlierIdx,1),pin(inlierIdx,2),'r')
    scatter(pin(~inlierIdx,1),pin(~inlierIdx,2),'b')
    subplot(1,2,2)
    imshow(Iout,[])
    hold on
    scatter(pout(inlierIdx,1),pout(inlierIdx,2),'r')
    scatter(pout(~inlierIdx,1),pout(~inlierIdx,2),'b')
    legend('满足极线约束','不满足极线约束')
    v = pout - pin;
end

figure(2)
clf()
plot(d)
hold on
bbox = frame_info.target(frame,:);
for i = 1:1:size(pout,1)
    if pout(i,1)>bbox(1)&&pout(i,1)<bbox(1)+bbox(3)&&pout(i,2)>bbox(2)&&pout(i,2)<bbox(2)+bbox(4)
        scatter(i,d(i),'r')
    end
end
hold off

figure(3)
clf()
scatter(v(:,1),v(:,2),'b')
hold on
for i = 1:1:size(pout,1)
    if pout(i,1)>bbox(1)&&pout(i,1)<bbox(1)+bbox(3)&&pout(i,2)>bbox(2)&&pout(i,2)<bbox(2)+bbox(4)
        hold on
        scatter(v(i,1),v(i,2),'r')
    end
end
hold off

