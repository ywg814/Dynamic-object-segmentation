%% 参数管理
function parameterManagement()
global parameter
parameter.SURFF_para = 200;             % SURF角点检测参数    值越大，点越少

parameter.myDBSCAN_thr = 0.7*[1.3 0.5 1.1]; % 时间域滤波参数  thr*[mediuam max mean],阈值越小判断为疑似目标的点越多[1.3 0.5 1.3]
parameter.isSatisfiePlane_thr = 10;      % 是否满足平面约束 thr*std    8    值越大，条件越严

%% 空间域滤波
parameter.temporalFiltering_thr = 3;      % 空间域滤波连续thr帧不为背景判断为目标,目前默认值为3
parameter.myIsoData_para.K = 3;         % 预估聚类数目
parameter.myIsoData_para.theta_N = 1;   % 每一聚类域中最少的样本数目
parameter.myIsoData_para.theta_S = 20;   % 一个样本的标准差阈值
parameter.myIsoData_para.theta_c = 50;  % 合并聚类中心距离参数
parameter.myIsoData_para.I = 30;        % 迭代次数
parameter.myIsoData_para.N_c = 1;        % 记录的聚类数目
 
%% 背景减法
parameter.back_thr = 50;    %detectObject ,切割前景与背景
parameter.r = 0.8;    %detectObject ,切割前景与背景
parameter.L = 30;    %与目标最大距离
