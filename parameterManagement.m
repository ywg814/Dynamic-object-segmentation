%% ��������
function parameterManagement()
global parameter
parameter.SURFF_para = 100;             % SURF�ǵ������
parameter.myDBSCAN_thr = 0.3*[1.3 0.5 1.1]; % �ռ����˲�����  thr*[mediuam max mean],��ֵԽС�ж�Ϊ����Ŀ��ĵ�Խ��[1.3 0.5 1.3]
parameter.isSatisfiePlane_thr = 8;      % �Ƿ�����ƽ��Լ�� thr*std
parameter.temporalFiltering_thr = 3;      % �ռ����˲�����thr֡��Ϊ�����ж�ΪĿ��,ĿǰĬ��ֵΪ3

%% �ռ����˲�
parameter.myIsoData_para.K = 3;         % Ԥ��������Ŀ
parameter.myIsoData_para.theta_N = 2;   % ÿһ�����������ٵ�������Ŀ
parameter.myIsoData_para.theta_S = 30;   % һ�������ı�׼����ֵ
parameter.myIsoData_para.theta_c = 20;  % �ϲ��������ľ������
parameter.myIsoData_para.I = 20;        % ��������
parameter.myIsoData_para.N_c = 1;        % ��¼�ľ�����Ŀ
 
