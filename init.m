B=20e6;%总带宽20Mhz
M=20;%CUE数目
K=20;%DUE数目
%dmb=30+20*rand(M,1);%CUE与基站之间的距离 （30，50）m
%dmk=10+20*rand(M,1);%CUE与DUE之间的距离（10,30）m
FM=(1+9*rand(M,1)).*1e8;%本地cpu计算频率（0.1-1）Ghz
CM=500+1000*rand(M,1);%一个bit需要的cpu周期数(500,1500)cycles/bit
DM=(100+400*rand(M,1)).*1e3;%每个CUE用户的数据量(100,500)KB
DK=DM;%每个DUE用户的数据量(100,500)KB
FC_max=6e9;%基站总的计算能力限制
HM=-50+20*rand(M,1);%信道增益,(-50,-30)dbm
FCM=1e11/M;%每个CUE用户分配的计算速率（100G/M）
PML=1e-8;%CUE本地耗能功率
PM=0.1;%CUE初始发射功率限制 0.1w
PKD_max_dbm=23;%DUE最大发射功率
PMC_max_dbm=23;%CUE最大发射功率
%PKD_max=power(10,PKD_max_dbm/10)/1000;
%PMC_max=power(10,PMC_max_dbm/10)/1000;
N0_dbm=-114;%噪声功率谱密度，dbm
rd0_db=5;%rd0 DUE终端的SINR门限值为5db
%a,b能耗和时延的权衡
a=0.5;
b=0.5;
% p0 DUE之间可靠性概率
%p0=0.001;
