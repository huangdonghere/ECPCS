%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo for ECPCS-MC, which is an ensemble clustering algorithm  %
% proposed in the following paper:                                        %
%                                                                         %
% D. Huang, C.-D. Wang, H. Peng, J. Lai, & C.-K. Kwoh. "Enhanced Ensemble %
% Clustering via Fast Propagation of Cluster-wise Similarities."To appear %
% in IEEE Transactions on Systems, Man, and Cybernetics: Systems.         %
% DOI: 10.1109/TSMC.2018.2876202                                          %
%                                                                         %
% The code has been tested in Matlab R2016a and Matlab R2016b.            %
%                                                                         %
% www.researchgate.net/publication/328581758                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function demo_1_ECPCS_MC()
%% Run the ECPCS-MC algorithm multiple times and show its average performance.

clear all;
close all;
clc;

%% Set up
addpath('Ncut');
M = 20;   % The number of base clusterings
cntTimes = 10;  % The number of times that the ECPCS-MC algorithm will be run.

%% Load the data.
dataName = 'BC';  
% dataName = 'PD';

data = [];
load(['data_',dataName,'.mat'],'data'); 
gt = data(:,1);
fea = data(:,2:end);
clear data

[N, d] = size(fea);
K = numel(unique(gt)); % The number of classes


%% Ensemble clustering (by ECPCS-MC)
nmiScores = zeros(cntTimes,1);
disp('====================================================================');
disp(['Performing ensemble clustering on the ', dataName, ' dataset ',num2str(cntTimes),' times.']);
disp(['N = ',num2str(N)]);
disp('====================================================================');
for runIdx = 1:cntTimes
    disp('********************************************************************');
    disp(['Run ', num2str(runIdx),':']);
    disp('********************************************************************');
    
    %% Generating M base clusterings
    lowerK = K;
    upperK = min(100,floor(sqrt(N)));
    disp(['Generating ',num2str(M),' base clusterings...']);
    tic;
    % The non-paralleled version
%     baseCls = EnsembleGeneration(fea, M, lowerK, upperK); 
    % The paralleled version
    baseCls = EnsembleGeneration_parallel(fea, M, lowerK, upperK);  
    toc;

    %% Performing ECPCS-MC to obtain the consensus clustering.
    disp('Starting ECPCS-MC...');
    tic;
    % You can use the default parameter t=20.
    Label = ECPCS_MC(baseCls, K);
    % Or you can set up parameter t by yourself.
%     t = 20;   % The number of steps of the random walks
%     Label = ECPCS_MC(baseCls, K,t);
    disp('ECPCS-MC done.');
    toc;
    
    disp('--------------------------------------------------------------------'); 
    nmiScores(runIdx) = NMImax(Label,gt);
    disp(['The NMI score at Run ',num2str(runIdx), ': ',num2str(nmiScores(runIdx))]);   
    disp('--------------------------------------------------------------------');
end

disp('********************************************************************');
disp(['Average Performance (w.r.t. true-k) over ',num2str(cntTimes),' runs on the ',dataName,' dataset']);
disp(['Sample size: N = ', num2str(N)]);
disp(['Dimension:   d = ', num2str(d)]);
disp(['Ensemble size: M = ', num2str(M)]);
disp('--------------------------------------------------------------------');
disp(['Average NMI score: ',num2str(mean(nmiScores))]);
disp('--------------------------------------------------------------------');
disp('********************************************************************');
