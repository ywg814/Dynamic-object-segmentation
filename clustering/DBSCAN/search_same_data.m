function zero_ind = search_same_data(data,xi_data)
    dist = pdist2(data,xi_data);
    zero_ind = find(dist==0);
end