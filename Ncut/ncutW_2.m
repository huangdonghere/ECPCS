function [NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW_2(W,nbcluster);
% [NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W,nbcluster);
% 
% Calls ncut to compute NcutEigenvectors and NcutEigenvalues of W with nbcluster clusters
% Then calls discretisation to discretize the NcutEigenvectors into NcutDiscrete
% Timothee Cour, Stella Yu, Jianbo Shi, 2004

% compute continuous Ncut eigenvectors
[NcutEigenvectors,NcutEigenvalues] = ncut_2(W,nbcluster);

% compute discretize Ncut vectors
[NcutDiscrete,NcutEigenvectors] =discretisation(NcutEigenvectors);


NcutDiscrete = full(NcutDiscrete);