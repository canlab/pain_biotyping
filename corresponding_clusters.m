function [idx1,idx2] = corresponding_clusters(idx1_old,idx2_old)

% Finds corresponding clusters in both data sets (idxN = indexes of objects
% in data set N) and replaces the indexes in idx2 so that they both have
% the same cluster labels


nb_clusters = numel(unique(idx1_old));

clusters_dataset1 = 1:4;
[~,~,clusters_dataset2] = compare_cluster(idx1_old,idx2_old);

idx2 = zeros(size(idx2_old));
idx1 = idx1_old;

% Replacement in idx2
for i=1:numel(idx2)
    j = 1;
    while j<=nb_clusters
        if idx2_old(i) == clusters_dataset2(j)
            idx2(i) = clusters_dataset1(j);
            j = nb_clusters;
        end
        j = j+1;
    end
end


    
end
    
    
    
    
    
    
    
    
