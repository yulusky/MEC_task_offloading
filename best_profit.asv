%计算最优配对方案下的各种指标

%最优的配对方案
match=KM(profit_mat);

%根据配对结果求CUE的SINR
rmc_arr=zeros(M,1);
for i=1:M
  %rmc_arr(i)=PMC_best_dbm(i).*hmb./(N0_dbm+PKD_best_dbm(match(i)).*hkb);
  rmc_arr(i)=power(10,PMC_best_dbm(i)/10).*1e-3.*power(10,hmb/10)./(power(10,N0_dbm/10).*1e-3+power(10,PKD_best_dbm(match(i))/10).*1e-3.*power(10,hmb/10));
end
%根据配对结果求DUE的SINR
rkd_arr=zeros(M,1);
for i=1:M
  rkd_arr(match(i))=power(10,PKD_best_dbm(match(i))/10).*1e-3.*power(10,hmb/10)./(power(10,N0_dbm/10).*1e-3+power(10,PMC_best_dbm(i)/10).*1e-3.*power(10,hmb/10));
  %rkd_arr(match(i))=PKD_best_dbm(match(i)).*hkb./(N0_dbm+PMC_best_dbm(i).*hmk);
end

%CUE信道上传速率
RMV_arr=B/M.*log2(1+rmc_arr);
%DUE信道上传速率
RKV_arr=B/M.*log2(1+rkd_arr);
%CUE本地时延
tm_loc_arr=DM.*CM./FM;
%CUE每个任务最大时延
tm_max_arr=tm_loc_arr;
%DUE任务最大上传时延
tk_max_arr=tm_loc_arr;
%CUE上传时延矩阵
tm_up_arr=DM./RMV_arr;
%DUE上传时延矩阵
tk_up_arr=DK./RKV_arr;
%CUE服务器计算时延
tm_c_arr=DM.*CM./FCM;
%CUE卸载总时延矩阵
tm_off_arr=tm_up_arr+tm_c_arr;
%CUE本地能耗
em_loc_arr=PML.*DM.*CM;
%CUE迁移能耗
em_off_arr=power(10,PMC_best_dbm(i)/10).*1e-3.*DM./RMV_arr;
%计算最优情况下的效益函数
profit_arr=a.*(tm_loc_arr-tm_off_arr)./tm_loc_arr+b.*(em_loc_arr-em_off_arr)./tm_loc_arr;



