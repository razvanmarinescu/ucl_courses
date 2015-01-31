function q132()
% fits the following models: BallStick, Diffusion Tensor, Zeppelin-Stick
% and Zeppelin-Stick with tortuosity


% BallStick model
%[paramsBallStick, SSDDBallStick] = q131();
load('q131BallStick.mat');

% Diffusion Tensor model
%[paramsDiffTensor, SSDDiffTensor] = q132DiffTensor();
load('q132DiffTensor.mat');

% Zeppelin-Stick
[paramsZeppStick, SSDZeppStick] = q132ZeppStick();

% Zeppelin-Stick with tortuosity
%[paramsZeppStickTort, SSDZeppStickTort] = q132ZeppStickTort();




end