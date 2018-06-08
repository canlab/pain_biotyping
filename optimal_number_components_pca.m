function [opt_nb_components,balanced_accuracy] = optimal_number_components_pca(maps1,maps2)

% Searches for the optimal number of PCA components used for the clustering
% in the PCA reduced maps.
%
% Tests numbers between 1 and 300 (95% of the variance is explained with
% about 250 components)
%
% For each number: use of 'cluster_maps_dim_reduction.m' function for each
% set of maps (maps1 and maps2)
% Then 'compare_cluster.m' to find the balanced accuracy of reproducibility
% between the two data sets
%
% Plots the balanced accuracy as a function of the number of components

number_to_test = [2 3 5 7 10 12 15 17 20 22 25 30 35 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210 220 230 240 250 260 270 280 290 300];
balanced_accuracy = zeros(numel(number_to_test),1);

j = 1;
for i=number_to_test 
    idx1 = cluster_maps_dim_reduction(maps1,4,i,2);
    idx2 = cluster_maps_dim_reduction(maps2,4,i,2);
    
    [~,balanced_accuracy(j)] = compare_cluster(idx1,idx2);
    j = j + 1;
end

plot(number_to_test,balanced_accuracy,'LineWidth',2,'Color',[.8 .2 .6]);
xlabel('Number of components in PCA')
ylabel('Balanced accuracy')
ylim([30 70])

[~,idx_opt] = max(balanced_accuracy);
opt_nb_components = number_to_test(idx_opt);

end

    