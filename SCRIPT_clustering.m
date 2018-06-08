tic
%% ------------------------ Load data -----------------------------------%

% Adds paths, loads 13 single-trials studies as array of fmri_data objects

%%%% Adding paths for matlab functions (from CanlabCore and personal
%%%% functions)

addpath(genpath('/projects/bope9760'));
addpath(genpath('/projects/nova3832/pain_biotyping'));


%%%% Load data
%%%% From /projects/nova3832/pain_biotyping/resources -> change path in fct

[studies,nb_participants,nb_single_trials] = import_and_normalize;


%% Construction of the individual maps with multivariate weights

% Constructs the multivariate maps with odd-even runs using predict.m 
% function: mv_maps 1 is for  clustering, mv_maps2 is for testing 
% reliability/reproducibility

[mv_maps1,mv_maps2] = multivariate_maps(studies,nb_participants);

% Entire maps
mv_maps_all = multivariate_maps_entire(studies,nb_participants);


%% Construction of the individual maps with univariate weights

% Constructs the univariate maps with odd-even runs using predict.m 
% function: uv_maps 1 is for  clustering, uv_maps2 is for testing 
% reliability/reproducibility

[uv_maps1,uv_maps2] = univariate_maps(studies,nb_participants);

% Entire maps
uv_maps_all = univariate_maps_entire(studies,nb_participants);


%% Remove participants with NaN
% This step is necessary for further study

[row_nan1,~] = find(isnan(mv_maps1));
[row_nan2,~] = find(isnan(mv_maps2));
[row_nan3,~] = find(isnan(uv_maps1));
[row_nan4,~] = find(isnan(uv_maps2));

rows = row_nan1;
rows = cat(1,rows,row_nan2);
rows = cat(1,rows,row_nan3);
rows = cat(1,rows,row_nan4);

rows_to_remove = unique(rows);

mv_maps1 = removerows(mv_maps1,rows_to_remove);
mv_maps2 = removerows(mv_maps2,rows_to_remove);
uv_maps1 = removerows(uv_maps1,rows_to_remove);
uv_maps2 = removerows(uv_maps2,rows_to_remove);

mv_maps_all = removerows(mv_maps_all,rows_to_remove);
uv_maps_all = removerows(uv_maps_all,rows_to_remove);


%% Signatures patterns

%%%%% Multivariate maps:

% Finds clusters
[idx_mv1_sign_old,C_mv1_sign,coord_mv1_sign] = cluster_signatures(mv_maps1,4);
[idx_mv2_sign_old,C_mv2_sign,coord_mv2_sign] = cluster_signatures(mv_maps2,4);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_mv_sign,bal_mv_sign,~,idx_mv1_sign,idx_mv2_sign,wrong_mv_sign] = compare_cluster_and_plot(idx_mv1_sign_old,idx_mv2_sign_old,coord_mv1_sign,coord_mv2_sign,C_mv1_sign,C_mv2_sign,'sign');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_mv1_sign,idx_mv2_sign,coord_mv1_sign,coord_mv2_sign,wrong_mv_sign,'sign');
%
% Compute correlation between signatures responses
[sign_mv1,sign_mv2,corr_mv12] = compare_signatures(coord_mv1_sign,coord_mv2_sign);
%
% Permutation tests for the balanced reliability
p_rel_mv_sign = perm_test_reliability(idx_mv1_sign,idx_mv2_sign,100000);
%
% Permutation tests for the correlation between cluster average maps
p_corr_mv_sign = perm_test_correlation(mv_maps1,mv_maps2,idx_mv1_sign,idx_mv2_sign,1000);
% 
% Display montage plots
clusters_mv1_sign = zeros(4,352328);
clusters_mv2_sign = zeros(4,352328);

for i=1:4
    clusters_mv1_sign(i,:) = transpose(mv_maps1(idx_mv1_sign==i,:));
    clusters_mv2_sign(i,:) = transpose(mv_maps2(idx_mv2_sign==i,:));
end
ttest_cluster(clusters_mv2_sign(1));

% Display dendrogram
make_dendrogram(coord_mv1_sign);



%%%%% Univariate maps:

% Finds clusters
[idx_uv1_sign_old,C_uv1_sign,coord_uv1_sign] = cluster_signatures(uv_maps1,4);
[idx_uv2_sign_old,C_uv2_sign,coord_uv2_sign] = cluster_signatures(uv_maps2,4);
% 

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_uv_sign,bal_uv_sign,~,idx_uv1_sign,idx_uv2_sign,wrong_uv_sign] = compare_cluster_and_plot(idx_uv1_sign_old,idx_uv2_sign_old,coord_uv1_sign,coord_uv2_sign,C_uv1_sign,C_uv2_sign,'sign');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_uv1_sign,idx_uv2_sign,coord_uv1_sign,coord_uv2_sign,wrong_uv_sign,'sign');

% Compute correlation between signatures responses
[sign_uv1,sign_uv2,corr_uv12] = compare_signatures(coord_uv1_sign,coord_uv2_sign);

% Permutation tests for the balanced reliability
p_rel_uv_sign = perm_test_reliability(idx_uv1_sign,idx_uv2_sign,100000);

% Permutation tests for the correlation between cluster average maps
p_corr_uv_sign = perm_test_correlation(uv_maps1,uv_maps2,idx_uv1_sign,idx_uv2_sign,1000);

% Display montage plots
clusters_uv1_sign = zeros(4,352328);
clusters_uv2_sign = zeros(4,352328);

for i=1:4
    clusters_uv1_sign(i,:) = transpose(uv_maps1(idx_uv1_sign==i,:));
    clusters_uv2_sign(i,:) = transpose(uv_maps2(idx_uv2_sign==i,:));
end
ttest_cluster(clusters_uv2_sign(1));

% Display dendrogram
make_dendrogram(coord_uv1_sign);

%% Entire maps

%%%%% Multivariate maps:

% Finds clusters
[idx_mv1_entire_old,C_mv1_entire,coord_mv1_entire] = cluster_maps(mv_maps1,4,2);
[idx_mv2_entire_old,C_mv2_entire,coord_mv2_entire] = cluster_maps(mv_maps2,4,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_mv_entire,bal_mv_entire,~,idx_mv1_entire,idx_mv2_entire,wrong_mv_entire] = compare_cluster_and_plot(idx_mv1_entire_old,idx_mv2_entire_old,coord_mv1_entire,coord_mv2_entire,C_mv1_entire,C_mv2_entire,'entire');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_mv1_entire,idx_mv2_entire,coord_mv1_entire,coord_mv2_entire,wrong_mv_entire,'entire');

% Display dendrogram
make_dendrogram(coord_mv1_entire);


%%%%% Univariate maps:

% Finds clusters
[idx_uv1_entire_old,C_uv1_entire,coord_uv1_entire] = cluster_maps(uv_maps1,4,2);
[idx_uv2_entire_old,C_uv2_entire,coord_uv2_entire] = cluster_maps(uv_maps2,4,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_uv_entire,bal_uv_entire,~,idx_uv1_entire,idx_uv2_entire,wrong_uv_entire] = compare_cluster_and_plot(idx_uv1_entire_old,idx_uv2_entire_old,coord_uv1_entire,coord_uv2_entire,C_uv1_entire,C_uv2_entire,'entire');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_uv1_entire,idx_uv2_entire,coord_uv1_entire,coord_uv2_entire,wrong_uv_entire,'entire');

% Display dendrogam
make_dendrogram(coord_uv1_entire);


%% PCA reduced maps

%%%%% Multivariate maps:

% Optimal number of components to use in PCA
opt_nb_components_mv = optimal_number_components_pca(mv_maps1,mv_maps2);

% Finds clusters
[idx_mv1_pca_old,C_mv1_pca,coord_mv1_pca] = cluster_maps_dim_reduction(mv_maps1,4,opt_nb_components_mv,2);
[idx_mv2_pca_old,C_mv2_pca,coord_mv2_pca] = cluster_maps_dim_reduction(mv_maps2,4,opt_nb_components_mv,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_mv_pca,bal_mv_pca,~,idx_mv1_pca,idx_mv2_pca,wrong_mv_pca] = compare_cluster_and_plot(idx_mv1_pca_old,idx_mv2_pca_old,coord_mv1_pca,coord_mv2_pca,C_mv1_pca,C_mv2_pca,'pca');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_mv1_pca,idx_mv2_pca,coord_mv1_pca,coord_mv2_pca,wrong_mv_pca,'pca');

% Permutation tests for the balanced reliability
p_rel_mv_pca = perm_test_reliability(idx_mv1_pca,idx_mv2_pca,100000);

% Permutation tests for the correlation between cluster average maps
p_corr_mv_pca = perm_test_correlation(mv_maps1,mv_maps2,idx_mv1_pca,idx_mv2_pca,1000);

% Display montage plots
clusters_mv1_pca = zeros(4,352328);
clusters_mv2_pca = zeros(4,352328);

for i=1:4
    clusters_mv1_pca(i,:) = transpose(mv_maps1(idx_mv1_pca==i,:));
    clusters_mv2_pca(i,:) = transpose(mv_maps2(idx_mv2_pca==i,:));
end
ttest_cluster(clusters_mv2_pca(1));

% Display dendrogram
make_dendrogram(coord_mv2_pca);



%%%%% Univariate maps:

% Optimal number of components to use in PCA
[opt_nb_components_uv,bal_acc_uv] = optimal_number_components_pca(uv_maps1,uv_maps2);

% Finds clusters
[idx_uv1_pca_old,C_uv1_pca,coord_uv1_pca] = cluster_maps_dim_reduction(uv_maps1,4,opt_nb_components_uv,2);
[idx_uv2_pca_old,C_uv2_pca,coord_uv2_pca] = cluster_maps_dim_reduction(uv_maps2,4,opt_nb_components_uv,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_uv_pca,bal_uv_pca,~,idx_uv1_pca,idx_uv2_pca,wrong_uv_pca] = compare_cluster_and_plot(idx_uv1_pca_old,idx_uv2_pca_old,coord_uv1_pca,coord_uv2_pca,C_uv1_pca,C_uv2_pca,'pca');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_uv1_pca,idx_uv2_pca,coord_uv1_pca,coord_uv2_pca,wrong_uv_pca,'pca');

% Permutation tests for the balanced reliability
p_rel_uv_pca = perm_test_reliability(idx_uv1_pca,idx_uv2_pca,100000);

% Permutation tests for the correlation between cluster average maps
p_corr_uv_pca = perm_test_correlation(uv_maps1,uv_maps2,idx_uv1_pca,idx_uv2_pca,1000);

% Display montage plots
clusters_uv1_pca = zeros(4,352328);
clusters_uv2_pca = zeros(4,352328);

for i=1:4
    clusters_uv1_pca(i,:) = transpose(uv_maps1(idx_uv1_pca==i,:));
    clusters_uv2_pca(i,:) = transpose(uv_maps2(idx_uv2_pca==i,:));
end
ttest_cluster(clusters_uv2_pca(1));

% Display dendrogram
make_dendrogram(coord_uv2_pca);


%% Bucknerlab reduced maps

%%%%% Multivariate maps: 

% Finds clusters
[idx_mv1_buck_old,C_mv1_buck,coord_mv1_buck] = cluster_maps_summarized(mv_maps1,4,2);
[idx_mv2_buck_old,C_mv2_buck,coord_mv2_buck] = cluster_maps_summarized(mv_maps2,4,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_mv_buck,bal_mv_buck,~,idx_mv1_buck,idx_mv2_buck,wrong_mv_buck] = compare_cluster_and_plot(idx_mv1_buck_old,idx_mv2_buck_old,coord_mv1_buck,coord_mv2_buck,C_mv1_buck,C_mv2_buck,'buck');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_mv1_buck,idx_mv2_buck,coord_mv1_buck,coord_mv2_buck,wrong_mv_buck,'buck');

% Display dendrogram
make_dendrogram(coord_mv2_buck);


%%%%% Univariate maps: 

% Finds clusters
[idx_uv1_buck_old,C_uv1_buck,coord_uv1_buck] = cluster_maps_summarized(uv_maps1,4,2);
[idx_uv2_buck_old,C_uv2_buck,coord_uv2_buck] = cluster_maps_summarized(uv_maps2,4,2);

% Compare clusters, plots the clusters and Silhouette values with 
% corresponding labels 
[glob_uv_buck,bal_uv_buck,~,idx_uv1_buck,idx_uv2_buck,wrong_uv_buck] = compare_cluster_and_plot(idx_uv1_buck_old,idx_uv2_buck_old,coord_uv1_buck,coord_uv2_buck,C_uv1_buck,C_uv2_buck,'buck');

% Plots the wrong assigments on top of the real clusters
plot_wrong_assignments(idx_uv1_buck,idx_uv2_buck,coord_uv1_buck,coord_uv2_buck,wrong_uv_buck,'buck');

% Display dendrogram
make_dendrogram(coord_uv2_buck);


%% Compare all clusters

[sign_mv_balanced,sign_uv_balanced,pca_mv_balanced,pca_uv_balanced,sign_mvuv_balanced,pca_mvuv_balanced,mv_balanced,uv_balanced] = compare_all_clusters(mv_maps1,mv_maps2,uv_maps1,uv_maps2)


%% Clustering per study

% Clusters per study, each study is represented by a color.
% Generates clusters both for signatures responses and entire maps with
% t-SNE visualization

clustering_per_study(studies,mv_maps1);





toc



