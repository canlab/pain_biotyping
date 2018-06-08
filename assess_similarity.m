function corr_matrix = assess_similarity(maps1,maps2,idx1,idx2)

% Assesses the similarity between clusters. Each cluster (in maps1 and
% maps2) is represented by its centroid, i.e. the average maps from all the
% subjects belonging to that cluster.
% Then, the spatial correlation between the different clusters is evaluated
% with corr.m, on the different clusters centroids.
%
% Returns a nb_clusters x nb_clusters matrix corresponding to the 
% correlations. The diagonal elements correspond to within-cluster 
% correlations and the non-diagonal ones correspond to between-cluster 
% correlations.



nb_clusters = numel(unique(idx1));
mean_cluster_maps1 = zeros(size(maps1,2),nb_clusters);
mean_cluster_maps2 = zeros(size(maps2,2),nb_clusters);

for i=1:nb_clusters
    mean_cluster_maps1(:,i) = transpose(mean(maps1(idx1==i,:),'omitnan'));
    mean_cluster_maps2(:,i) = transpose(mean(maps2(idx2==i,:),'omitnan'));
end


corr_matrix = zeros(nb_clusters);

for i=1:nb_clusters
    for j=1:nb_clusters
        corr_matrix(i,j) = corr(mean_cluster_maps1(:,i),mean_cluster_maps2(:,j));
    end
end

corr_matrix


end


