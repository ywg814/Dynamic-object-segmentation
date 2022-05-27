function output_data = set_across(act_data,pas_data)
% this function is doing output_data = act_data ¡Épas_data
output_data = [];
[PD_rows,~] = size(pas_data);
for i =1:PD_rows
    delta_ind = search_same_data(act_data,pas_data(i,:));
    if ~isempty(delta_ind)
       output_data = [output_data;pas_data(i,:)];
    else
        continue;
    end
end
 
end