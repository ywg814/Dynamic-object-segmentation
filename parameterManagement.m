%% ��������
function parameterManagement()
global parameter
parameter.SURFF_para = 200;             % SURF�ǵ������    ֵԽ�󣬵�Խ��

parameter.myDBSCAN_thr = 0.7*[1.3 0.5 1.1]; % ʱ�����˲�����  thr*[mediuam max mean],��ֵԽС�ж�Ϊ����Ŀ��ĵ�Խ��[1.3 0.5 1.3]
parameter.isSatisfiePlane_thr = 10;      % �Ƿ�����ƽ��Լ�� thr*std    8    ֵԽ������Խ��

%% �ռ����˲�
parameter.temporalFiltering_thr = 3;      % �ռ����˲�����thr֡��Ϊ�����ж�ΪĿ��,ĿǰĬ��ֵΪ3
parameter.myIsoData_para.K = 3;         % Ԥ��������Ŀ
parameter.myIsoData_para.theta_N = 1;   % ÿһ�����������ٵ�������Ŀ
parameter.myIsoData_para.theta_S = 20;   % һ�������ı�׼����ֵ
parameter.myIsoData_para.theta_c = 50;  % �ϲ��������ľ������
parameter.myIsoData_para.I = 30;        % ��������
parameter.myIsoData_para.N_c = 1;        % ��¼�ľ�����Ŀ
 
%% ��������
parameter.back_thr = 50;    %detectObject ,�и�ǰ���뱳��
parameter.r = 0.8;    %detectObject ,�и�ǰ���뱳��
parameter.L = 30;    %��Ŀ��������
