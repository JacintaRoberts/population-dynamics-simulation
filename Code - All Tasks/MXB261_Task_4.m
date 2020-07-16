%% Task 4 - Spatial agent-based implementation

%% Test different combinations of parameters
clear;
close all;

% SpatialAgentWalk(filename,no_frames,PD,pos,f1,f2,f3)

% IMPORTANT: The uncommented calls were used to generate results in
% the report. Only run 1 line at a time to prevent system overload.

% Initial Population Density Sweep:
% Area 1, Position 1 (randomised - 40 000 units), increasing initial population density
SpatialAgentWalk('pop10%.avi',150,0.1,[200,0,200,0],10,0.02,300);
SpatialAgentWalk('pop20%(control).avi',150,0.2,[200,0,200,0],10,0.02,300); % Control
SpatialAgentWalk('pop30%.avi',150,0.3,[200,0,200,0],10,0.02,300);
SpatialAgentWalk('pop40%.avi',150,0.4,[200,0,200,0],10,0.02,300);

% Location and Area Sweep:
% Area 2, Position 2 (top right - 22 500 units) 150x150
SpatialAgentWalk('pos2.avi',150,0.2,[150,50,150,0],10,0.02,300);
% Area 2, Position 3 (centre - 22 500 units) 150x150
SpatialAgentWalk('pos3.avi',150,0.2,[150,25,150,25],10,0.02,300);
% Area 3, Position 4 (centre - 2500 units) 50x50
SpatialAgentWalk('pos4.avi',150,0.2,[50,75,50,75],10,0.02,300);
% Area 3, Position 5 (top right - 2500 units) 20x125
SpatialAgentWalk('pos5.avi',150,0.2,[20,180,125,0],10,0.02,300);

% f1 (parasite death rate) Sweep:
SpatialAgentWalk('f1=0.avi',150,0.2,[200,0,200,0],0,0.02,300); % f1 = 0
SpatialAgentWalk('f1=5.avi',150,0.2,[200,0,200,0],5,0.02,300); % f1 = 5
SpatialAgentWalk('f1=10.avi',150,0.2,[200,0,200,0],10,0.02,300); % f1 = 10 (control)
SpatialAgentWalk('f1=15.avi',150,0.2,[200,0,200,0],15,0.02,300); % f1 = 15

% f2 (food death rate) Sweep:
SpatialAgentWalk('f2=0.00.avi',150,0.2,[200,0,200,0],10,0.00,300); % f2 = 0.00
SpatialAgentWalk('f2=0.02.avi',150,0.2,[200,0,200,0],10,0.02,300); % f2 = 0.02 (control)
SpatialAgentWalk('f2=0.05.avi',150,0.2,[200,0,200,0],10,0.05,300); % f2 = 0.05
SpatialAgentWalk('f2=0.10.avi',150,0.2,[200,0,200,0],10,0.10,300); % f2 = 0.10

% f3 (food growth) Sweep:
SpatialAgentWalk('f3=100.avi',150,0.2,[200,0,200,0],10,0.02,100); % f3 = 100
SpatialAgentWalk('f3=200.avi',150,0.2,[200,0,200,0],10,0.02,200); % f3 = 200 (control)
SpatialAgentWalk('f3=300.avi',150,0.2,[200,0,200,0],10,0.02,300); % f3 = 300
SpatialAgentWalk('f3=400.avi',150,0.2,[200,0,200,0],10,0.02,400); % f3 = 400