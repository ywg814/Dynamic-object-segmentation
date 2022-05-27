%% ¼ÆËã±¾Õ÷¾ØÕó
function frame_info = cal_Fundamental(frame_info,frame)
[E, inlierIdx] = estimateFundamentalMatrix(frame_info.SURFF_pin{frame}, frame_info.SURFF_pout{frame});
pp1 = frame_info.SURFF_pin{frame};
pp2 = frame_info.SURFF_pout{frame};

d = computeDistance( pp1, pp2, E);%sampson

frame_info.FundamentalMatrix{frame,1}.E = E;
frame_info.FundamentalMatrix{frame,1}.inlierIdx = inlierIdx;
frame_info.FundamentalMatrix{frame,1}.d = d;


