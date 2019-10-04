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

function ECA = getECA(bcs,Sim)
% Compute the enhanced co-association (ECA) matrix.
% Dong Huang. Apr. 18, 2018.

[N,M] = size(bcs);
ECA = zeros(N,N);
Sim = Sim-diag(diag(Sim))+diag(ones(size(Sim,1),1));

for m = 1:M
    ECA = ECA + Sim(bcs(:,m),bcs(:,m));
end

ECA = ECA/M;