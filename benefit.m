%计算效益函数

%CUE信道上传速率
RMV_mat=B/M.*log2(1+rmc_mat);
%DUE信道上传速率
RKV_mat=B/M.*log2(1+rkd_mat);
%CUE本地时延
tm_loc_mat=DM.*CM./FM;
%CUE每个任务最大时延
tm_max_mat=tm_loc_mat;
%DUE任务最大上传时延
tk_max_mat=tm_loc_mat;
%CUE上传时延矩阵
tm_up_mat=zeros(M,K);
for i=1:M
  tm_up_mat(i,:)=DM(i)./RMV_mat(i,:);
end
%DUE上传时延矩阵
tk_up_mat=zeros(M,K);
for i=1:M
  tk_up_mat(i,:)=DK(i)./RKV_mat(i,:);
end
%CUE服务器计算时延
tm_c_mat=DM.*CM./FCM;
%CUE卸载总时延矩阵
tm_off_mat=zeros(M,K);
for i=1:M
  tm_off_mat(i,:)=tm_up_mat(i,:)+tm_c_mat(i);
end
%CUE本地能耗
em_loc_mat=PML.*DM.*CM;
%CUE迁移能耗
em_off_mat=zeros(M,K);
for i=1:M
  em_off_mat(i,:)=power(10,PMC_best_dbm(i)/10).*1e-3.*DM(i)./RMV_mat(i,:);
end
%效益函数
profit_mat=zeros(M,K);
for i=1:M
  profit_mat(i,:)=a.*(tm_loc_mat(i)-tm_off_mat(i,:))./tm_loc_mat(i)+b.*(em_loc_mat(i)-em_off_mat(i,:))./tm_loc_mat(i);
end







