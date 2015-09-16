%
%       HDR Toolbox demo 5:
%	   1) Load "Bottles_Small.hdr" HDR image
%      2) Activate the Interactive HDR Visualization tool
%      3) Write a .png file with the latest clicked exposure using
%      InteractiveHDRVis
%
%       Author: Francesco Banterle
%       Copyright June 2012 (c)
%
%
clear all;

disp('1) Load "Bottles_Small.hdr" HDR image');
img = hdrimread('Bottles_Small.hdr');
% img = hdrimread('E:\yangfan\DATA\HDR\INPUT\trafficLight.hdr');
% img = hdrimread('E:\yangfan\DATA\HDR\INPUT\camp_daylight_10am_sanfran_barn_006_d.hdr');
% img = hdrimread('E:\yangfan\DATA\HDR\INPUT\office.hdr');
% img = hdrimread('E:\yangfan\DATA\HDR\INPUT\vinesunset.hdr');
% img = hdrimread('E:\yangfan\DATA\HDR_IBL\HDR_110_Tunnel\HDR_110_Tunnel_Ref_ROI_1833_811_1610_972.hdr');

disp('2) Activate the Interactive HDR Visualization tool');
[img_cur_exp, exposure] = AExposureGUI(img);

% disp('3)  Write a .png file with the latest clicked exposure using InteractiveHDRVis');
imwrite(GammaTMO(img_cur_exp,2.2,0.0,0),'Venice01_int_vis.png');
