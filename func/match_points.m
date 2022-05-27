%% ÕºœÒµ„∆•≈‰

function frame_info = match_points(featuresIn ,validPtsIn,featuresOut,validPtsOut,frame_info,frame)
% 3.Match feature vectors.
index_pairs = matchFeatures(featuresIn, featuresOut);
% 4.Get matching points.
matchedPtsIn  = validPtsIn(index_pairs(:,1));
matchedPtsOut = validPtsOut(index_pairs(:,2));

pin = matchedPtsIn.Location;
pout= matchedPtsOut.Location;

frame_info = init_info(frame_info,pin,pout,[],frame);
