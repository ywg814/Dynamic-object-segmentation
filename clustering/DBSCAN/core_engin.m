%core engin
function [is_object, xi_object_samples] = core_engin(melon_data,xi_data)
% judge objects and get object samples
global delta_dist;
global min_pst;
is_object = 0;
xi_dist =  pdist2(melon_data,xi_data);
min_pst_ind= find(xi_dist<=delta_dist);
if length(min_pst_ind) >= min_pst % including xi itself
   is_object =1;
   xi_object_samples = melon_data(min_pst_ind,:);
else
    xi_object_samples =[];
end