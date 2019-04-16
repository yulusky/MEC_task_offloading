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
fun=@(PKD) ak_db*PKD/rd0_db/amk_db*(exp(-rd0_db*N0_dbm*1e-3/PKD/ak_db)/(1-p0)-1)-PMC_max;
PMC_max_PKD_max=fun(PKD_max)+PMC_max;
PKD_max_PMC_max=bisect1(fun,0,PKD_max,0.005);
PMC_best=min(PMC_max_PKD_max,PMC_max);
PKD_best=min(PKD_max_PMC_max,PKD_max);