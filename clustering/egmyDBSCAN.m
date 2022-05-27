clear
clc
format long
data = [rand(10,1);20+rand(20,1);10+rand(5,1);20+rand(20,1)];
Idx = myDBSCAN(data);