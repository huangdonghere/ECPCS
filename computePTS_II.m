%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If you find the code useful for your research, please cite the paper    %
% below:                                                                  %
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

function [newS] = computePTS_II(S, paraT)
% This function performs random walk on S, and obtains a new similarity
% matrix by comparing the random walk trajectories starting from different nodes.  
%
% Input:
% S:        the similarity matrix (of a graph)
% paraT:    the number of steps of random walk
% Output:
% newS:     the newly obtained similarity matrix 
%
% Dong Huang. Sep. 28, 2018.


N = size(S,1);


for i = 1:size(S,1), S(i,i)=0; end

rowSum = sum(S,2);
rowSums = repmat(rowSum, 1, N);
rowSums(rowSums==0)=-1;% find and label the isolated point
P = S./rowSums; % transition probability.
P(P<0)=0; % remove the isolated point.

%% Compute PTS
tmpP = P;
inProdP = P*P';
for ii = 1:(paraT-1)
    tmpP = tmpP*P;
    inProdP = inProdP + tmpP*tmpP';
end
inProdPii = repmat(diag(inProdP), 1, N);
inProdPjj = inProdPii';
newS = inProdP./sqrt(inProdPii.*inProdPjj);

sr = sum(P');
isolatedIdx = find(sr<10e-10);
if numel(isolatedIdx)>0
    newS(isolatedIdx,:) = 0;
    newS(:,isolatedIdx) = 0;
end