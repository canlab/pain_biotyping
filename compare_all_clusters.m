function [sign_mv_balanced,sign_uv_balanced,pca_mv_balanced,pca_uv_balanced,sign_mvuv_balanced,pca_mvuv_balanced,mv_balanced,uv_balanced] = compare_all_clusters(mv_maps1,mv_maps2,uv_maps1,uv_maps2)

% Compares the balanced reliability between clusters from multivariate and
% univariate maps, for signatures and for PCA reduced maps. The idea is to
% determine if the clusters found in different situations are the same.
%
%
% sign_mv_balanced = balanced reliability between clusters found in
% signatures responses on multivariate maps
%
% sign_uv_balanced = balanced reliability between clusters found in
% signatures responses on univariate maps
%
% pca_mv_balanced = balanced reliability between clusters found in
% PCA reduced multivariate maps
%
% pca_uv_balanced = balanced reliability between clusters found in
% PCA reduced univariate maps
%
% sign_mvuv_balanced = balanced reliability between clusters found in 
% signatures responses on multivariate VS univariate maps
%
% pca_mvuv_balanced = balanced reliability between clusters found in PCA
% reduced multivariate VS univariate maps
%
% mv_balanced = balanced reliability between clusters found in signatures
% responses VS PCA reduced multivariate maps
%
% uv_balanced = balanced reliability between clusters found in signatures
% responses VS PCA reduced univariate maps



% Multivariate - signatures
idx_mv1_sign = cluster_signatures(mv_maps1,4);
idx_mv2_sign = cluster_signatures(mv_maps2,4);

% Univariate - signatures
idx_uv1_sign = cluster_signatures(uv_maps1,4);
idx_uv2_sign = cluster_signatures(uv_maps2,4);

% Multivariate - PCA (15)
idx_mv1_pca = cluster_maps_dim_reduction(mv_maps1,4,15,2);
idx_mv2_pca = cluster_maps_dim_reduction(mv_maps2,4,15,2);

% Univariate - PCA (??)
idx_uv1_pca = cluster_maps_dim_reduction(uv_maps1,4,50,2);
idx_uv2_pca = cluster_maps_dim_reduction(uv_maps2,4,50,2);

% Compare clusters in signatures responses on multivariate maps
[sign_mv_global,sign_mv_balanced] = compare_cluster(idx_mv1_sign,idx_mv2_sign);
% Compare clusters in signatures responses on univariate maps
[sign_uv_global,sign_uv_balanced] = compare_cluster(idx_uv1_sign,idx_uv2_sign);


% Compare clusters in PCA reduced multivariate maps
[pca_mv_global,pca_mv_balanced] = compare_cluster(idx_mv1_pca,idx_mv2_pca);
% Compare clusters in PCA reduced univariate maps
[pca_uv_global,pca_uv_balanced] = compare_cluster(idx_uv1_pca,idx_uv2_pca);



% Compare clusters in signatures responses on multivariate VS univariate maps
[sign_mv1uv2_global,sign_mv1uv2_balanced] = compare_cluster(idx_mv1_sign,idx_uv2_sign);
[sign_mv1uv1_global,sign_mv1uv1_balanced] = compare_cluster(idx_mv1_sign,idx_uv1_sign);
[sign_mv2uv2_global,sign_mv2uv2_balanced] = compare_cluster(idx_mv2_sign,idx_uv2_sign);
[sign_mv2uv1_global,sign_mv2uv1_balanced] = compare_cluster(idx_mv2_sign,idx_uv1_sign);

sign_mvuv_global = (sign_mv1uv2_global + sign_mv1uv1_global + sign_mv2uv2_global + sign_mv2uv1_global)/4;
sign_mvuv_balanced = (sign_mv1uv2_balanced + sign_mv1uv1_balanced + sign_mv2uv2_balanced + sign_mv2uv1_balanced)/4;


% Compare clusters in PCA reduced multivariate VS univariate maps
[pca_mv1uv2_global,pca_mv1uv2_balanced] = compare_cluster(idx_mv1_pca,idx_uv2_pca);
[pca_mv1uv1_global,pca_mv1uv1_balanced] = compare_cluster(idx_mv1_pca,idx_uv1_pca);
[pca_mv2uv2_global,pca_mv2uv2_balanced] = compare_cluster(idx_mv2_pca,idx_uv2_pca);
[pca_mv2uv1_global,pca_mv2uv1_balanced] = compare_cluster(idx_mv2_pca,idx_uv1_pca);

pca_mvuv_global = (pca_mv1uv2_global + pca_mv1uv1_global + pca_mv2uv2_global + pca_mv2uv1_global)/4;
pca_mvuv_balanced = (pca_mv1uv2_balanced + pca_mv1uv1_balanced + pca_mv2uv2_balanced + pca_mv2uv1_balanced)/4;



% Compare clusters in signatures responses VS PCA reduced (multivariate
% maps)
[mv1mv2_global,mv1mv2_balanced] = compare_cluster(idx_mv1_sign,idx_mv2_pca);
[mv1mv1_global,mv1mv1_balanced] = compare_cluster(idx_mv1_sign,idx_mv1_pca);
[mv2mv2_global,mv2mv2_balanced] = compare_cluster(idx_mv2_sign,idx_mv2_pca);
[mv2mv1_global,mv2mv1_balanced] = compare_cluster(idx_mv2_sign,idx_mv1_pca);

mv_global = (mv1mv2_global + mv1mv1_global + mv2mv2_global + mv2mv1_global)/4;
mv_balanced = (mv1mv2_balanced + mv1mv1_balanced + mv2mv2_balanced + mv2mv1_balanced)/4;



% Compare clusters in signatures responses VS PCA reduced (univariate
% maps)
[uv1uv2_global,uv1uv2_balanced] = compare_cluster(idx_uv1_sign,idx_uv2_pca);
[uv1uv1_global,uv1uv1_balanced] = compare_cluster(idx_uv1_sign,idx_uv1_pca);
[uv2uv2_global,uv2uv2_balanced] = compare_cluster(idx_uv2_sign,idx_uv2_pca);
[uv2uv1_global,uv2uv1_balanced] = compare_cluster(idx_uv2_sign,idx_uv1_pca);

uv_global = (uv1uv2_global + uv1uv1_global + uv2uv2_global + uv2uv1_global)/4;
uv_balanced = (uv1uv2_balanced + uv1uv1_balanced + uv2uv2_balanced + uv2uv1_balanced)/4;

end