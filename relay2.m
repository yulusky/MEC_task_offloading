clear all
close all
clc
%-----------------------------升余弦滤波器
Fs=9600;            %采样频率
Ts=1/Fs;            %采样间隔
Fd=960;              %Doppler频偏，以Hz为单位
tau=[0,0.002];          %多径延时，以s为单位
pdf=[0,0];          %各径功率，以dB位单位
chan=rayleighchan(Ts,Fd,tau,pdf);
%-------------------------------通过信道
t=0:1/Fs:999*(1/Fs);
fc=96;
data=cos(2*pi*fc*t); %数据2 
y = filter(chan,data);%经过信道后的输出
plot(t,abs(y),'r',t,data,'c')