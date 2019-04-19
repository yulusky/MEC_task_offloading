%求最优发射功率
%PMC和PKD之间的关系
% PMC m个CUE的发射功率
% PKD k个DUE的发射功率 
%N0背景噪声
%rd0 允许v2v之间传输的最小速率
%ak_db v2v之间的大尺度衰落
%amk_db 第m DUE与第k CUE之间的大尺度衰落
%PMC m 个CUE的发射功率
%PKD k 个DUE的发射功率
%p0 DUE的可靠保证概率

%路径损耗
[all_loss_m_db,ak_db]=loss_all_big_DUE(100,3); 
[all_loss_k_db,~]=loss_all_big_DUE(20,3);
ak_db_arr=-40*rand(M,1);
amk_db_arr=-80*rand(M,1);
%ak=power(10,ak_db/10);
%amk=power(10,amk_db/10);
%使用db单位计算
%fun=@(PKD) ak_db*PKD/rd0_db/amk_db*(exp(-rd0_db*N0_dbm*1e-3/PKD/ak_db)/(1-p0)-1)-PMC_max_dbm*1e-3;
%转化为常数单位
% fun=@(PKD) power(10,ak_db/10)*power(10,PKD/10)*1e-3/power(10,rd0_db/10)/power(10,amk_db/10)*...
%     (exp(-power(10,rd0_db/10)*power(10,N0_dbm/10)*1e-3/power(10,PKD/10)*1e-3/...
%     power(10,ak_db/10))/(1-p0)-1)-power(10,PMC_max_dbm/10)*1e-3;
%中间结果使用dbm单位
% fun=@(PKD) 10*log10((power(10,ak_db/10)*power(10,PKD/10)*1e-3/power(10,rd0_db/10)/power(10,amk_db/10)*...
%     (exp(-power(10,rd0_db/10)*power(10,N0_dbm/10)*1e-3/power(10,PKD/10)*1e-3/...
%     power(10,ak_db/10))/(1-p0)-1))*1e3)-PMC_max_dbm;
% %dbm单位
% PMC_max_PKD_max=fun(PKD_max_dbm)+PMC_max_dbm;
% %dbm单位
% PKD_max_PMC_max=bisect1(fun,0,30,0.0005);
% %dbm表示结果
% PMC_best_dbm=min(PMC_max_PKD_max,PMC_max_dbm);
% PKD_best_dbm=min(PKD_max_PMC_max,PKD_max_dbm);
PMC_max_PKD_max=zeros(M,1);
PKD_max_PMC_max=zeros(M,1);
PMC_best_dbm=zeros(M,1);
PKD_best_dbm=zeros(M,1);
for i=1:M
    %dbm单位
    ak_db=ak_db_arr(i);
    amk_db=amk_db_arr(i);
    fun=@(PKD) 10*log10((power(10,ak_db/10)*power(10,PKD/10)*1e-3/power(10,rd0_db/10)/power(10,amk_db/10)*...
    (exp(-power(10,rd0_db/10)*power(10,N0_dbm/10)/power(10,PKD/10)/...
    power(10,ak_db/10))/(1-p0)-1))*1e3)-PMC_max_dbm;
    PMC_max_PKD_max(i)=fun(PKD_max_dbm)+PMC_max_dbm;
    %dbm单位
    PKD_max_PMC_max(i)=bisect1(fun,0,30,0.0005);
    %dbm表示结果
    PMC_best_dbm(i)=min(PMC_max_PKD_max(i),PMC_max_dbm);
    PKD_best_dbm(i)=min(PKD_max_PMC_max(i),PKD_max_dbm);
end
%测试
% a=17;
% b=23;
% PMC_best_dbm = a + (b-a).*rand(M,1);
% PKD_best_dbm=a + (b-a).*rand(M,1);

