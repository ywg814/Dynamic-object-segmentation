function output_data = set_diff(act_data,pas_data)
%this function is set operation  : output_data = act_data\pas_dataÈ¥³ı²Ù×÷
[m,~] = size(pas_data);
for i= 1:m
    delta_ind = search_same_data(act_data,pas_data(i,:));
    if ~isempty(delta_ind)
       act_data(delta_ind,:) =[];
    else
        continue;
    end
end
output_data = act_data;
end
 
