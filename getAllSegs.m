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

function [bcs, baseClsSegs] = getAllSegs(baseCls)
% Dong Huang. 19 April, 2013.
% Optimized for speed by Nejc Ilc, 5 June 2014

[N,nBC] = size(baseCls);
% n:    the number of data points.
% nBase:    the number of base clusterings.
% nCls:     the number of clusters (in all base clusterings).


bcs = baseCls;
nClsOrig = max(bcs,[],1);
C = cumsum(nClsOrig); 
bcs = bsxfun(@plus, bcs,[0 C(1:end-1)]);
nCls = nClsOrig(end)+C(end-1);
baseClsSegs = zeros(nCls,N);

for i=1:nBC 
    if i == 1
        startK = 1;
    else
        startK = (C(i-1)+1);
    end
    endK = C(i);
    searchVec = startK:endK;
    F = bsxfun(@eq,bcs(:,i),searchVec);
    baseClsSegs(searchVec,:) = F';
end






