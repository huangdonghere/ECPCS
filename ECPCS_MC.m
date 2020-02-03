%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code for ECPCS-MC, which is an ensemble clustering algorithm%
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

function Label = ECPCS_MC(baseCls, K, t)
% Dong Huang. Sep. 28, 2018.

if nargin < 3
    t = 20;
end

[N,M] = size(baseCls);

[bcs, baseClsSegs] = getAllSegs(baseCls);
clsSim = full(simxjac(baseClsSegs)); % Build the cluster similarity matrix by Jaccard coefficient.
clsSimRW = computePTS_II(clsSim, t); % Perform random walks and obtain a new cluster-wise similarity matrix.

% Meta-clustering
clsL = ncutW_2(clsSimRW, K);
for j = 2:size(clsL,2)
    clsL(:,j) = clsL(:,j) * j;
end
clsLabel = sum(clsL');
clsLabel_cum = zeros(K, N);
for i=1:max(clsLabel),
   matched_clusters = find(clsLabel==i);
   clsLabel_cum(i,:) = mean(baseClsSegs(matched_clusters,:),1);
end;
[~,Label]=max(clsLabel_cum); % Majority voting
    
 
