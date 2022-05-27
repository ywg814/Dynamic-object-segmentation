%% ≥ı ºªØframe_info

function frame_info = init_info(frame_info,pin,pout,zone,frame)
frame_info.SURFF_pin{frame,1}= pin;
frame_info.SURFF_pout{frame,1} = pout;
frame_info.SURFF_v{frame,1} = pout - pin;
if ~isempty(zone)
    frame_info.zone(frame,:) = zone;% [left,top,wight,hight]
end
% frame_info.LLT{frame}.fea = [];