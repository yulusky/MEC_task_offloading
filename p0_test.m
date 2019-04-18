%时延能耗关于p0的关系

p0_arr=[0.001:0.001:0.02]';
len=length(p0_arr);
tm_all_best_sum_arr=zeros(len,1);
em_all_best_sum_arr=zeros(len,1);
%初始化
init;
for i=1:len
    p0=p0_arr(i);
    %计算最优发射功率
    pbest;
    %构造信噪比矩阵
    SINR;
    %构造效益矩阵
    benefit;
    %KM算法计算最优信道复用模式
    best_profit;
    %求解背包问题计算最优卸载策略
    package;
    %x最优卸载策略
    %PMC_best_dbm CUE用户最优发射功率
    %PKD_best_dbm CUE用户最优发射功率
    %match 最优信道复用模式
    %tm_all_best最低时延
    %em_all_best最低能耗
    %tm_all_best_sum总时延
    %em_all_best_sum总能耗
    tm_all_best_sum_arr(i)=tm_all_best_sum;
    em_all_best_sum_arr(i)=em_all_best_sum;
end
plot(p0_arr,tm_all_best_sum_arr,'r');
plot(p0_arr,em_all_best_sum_arr,'r');
xlabel('p0');
ylabel('all delay');
grid on;