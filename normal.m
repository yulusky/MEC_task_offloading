close all; clear all; clc

x=-1:.1:1;

norm=normpdf(x,0,1);

plot(x,norm,'r-','LineWidth',3)

