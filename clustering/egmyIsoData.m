clear 
clc
data = [0 0;3 8;2 2;1 1;5 3;4 8;6 3;5 4;6 4;7 5];
para_iso_data.K = 3;para_iso_data.theta_N = 1;para_iso_data.theta_S = 1;para_iso_data.theta_c = 4;para_iso_data.L = 1;para_iso_data.I = 4;para_iso_data.N_c = 1;
[S, Z] = myIsoData(data, para_iso_data);
draw_cluster(S, Z);

