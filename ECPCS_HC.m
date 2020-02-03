%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code for ECPCS-HC, which is an ensemble clustering algorithm%
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

function Label = ECPCS_HC(baseCls, K, t)
% Dong Huang. Sep. 28, 2018.

if nargin < 3
    t = 20;
end

[bcs, baseClsSegs] = getAllSegs(baseCls);
clsSim = full(simxjac(baseClsSegs)); % Build the cluster similarity matrix by Jaccard coefficient.
clsSimRW = computePTS_II(clsSim, t); % Perform random walks and obtain a new cluster-wise similarity matrix.

ECA = getECA(bcs,clsSimRW);
Label = runHC(ECA, K); 

    
    
function Label = runHC(S, ks)
% Input: the similarity matrix
%        and the numbers of clusters.
% Output: the clustering result.

N = size(S,1);

d = stod(S); clear S %convert similarity matrix to distance vector
% average linkage 
Zal = linkage(d,'average'); clear d

Label = zeros(N,numel(ks));
for iK = 1:numel(ks)
    Label(:,iK) = cluster(Zal,'maxclust',ks(iK));
end

function d = stod(S)
% Dong Huang. Apr. 19, 2018. 

N = size(S,1);
s = zeros(1,(1+N-1)*(N-1)/2);
nextIdx = 1;
for a = 1:N-1 %change matrix's format to be input of linkage fn
    s(nextIdx:nextIdx+(N-a-1)) = S(a,[a+1:end]);
    nextIdx = nextIdx + N - a;
end
d = 1 - s;

 
