
%step1
function object_set = search_objects(melon_data)
object_set = [];
for i= 1:length(melon_data)
    [is_object, ~] = core_engin(melon_data,melon_data(i,:));
   if is_object % including xi itself
       object_set = [object_set;melon_data(i,:)];
   end
end
end




 

 
 

