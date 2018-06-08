function [idx,C,maps,sil_mean] = cluster_maps(maps,nb_clusters,nb_dimensions)

% Searches for nb_clusters clusters within the entire maps
%
% Plots the results in a two or three-dimensional space (determined by the
% user with nb_dimensions) using t-SNE. 
%
% Displays the Silhouette plot
%
% Returns the clusters labels (idx), the positions of the centroids (C),
% the mapped maps from t-SNE (mapped_maps) and the mean Silhouette value
% of the clusters (sil_mean)




% A dimension reduction is conducted with PCA only to allow the
% visualization with t-SNE (the color code in the final plot corresponds
% to the clusters labels found with k-means applied to the entire maps)

[~,score] = pca(maps,'NumComponents',250);



rng default;
% For reproducibility

opts = statset('Display','Final');


[idx,C] = kmeans_matlab(maps,nb_clusters,'Distance','cosine',...
    'Replicates',5,'Options',opts);

colors = {'b','r','g','y','k',[.5 .6 .7],[.8 .2 .6],[0 .5 0],[0 .75 .75],[.75 0 .75],[.75 .75 0],[1 .4 .6],[.5 0 .5]};

% t-SNE method
initial_dims = 100;
perplexity = 30;
    
mapped_maps = tsne(score,[],nb_dimensions,initial_dims,perplexity);

% Plots

if nb_dimensions==2
    figure;
    for i = 1:nb_clusters
        scatter(mapped_maps(idx==i,1),mapped_maps(idx==i,2),12,colors{i},'filled');
        hold on
    end
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
        'Location','NW');
    xlabel('x')
    ylabel('y')
    
        
elseif nb_dimensions==3
    figure;
    for i = 1:nb_clusters
        scatter3(mapped_maps(idx==i,1),mapped_maps(idx==i,2),mapped_maps(idx==i,3),12,colors{i},'filled');
        hold on
    end
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
        'Location','NW');    
    view(3), axis vis3d, box on, rotate3d on
    xlabel('x')
    ylabel('y')
    zlabel('z')
end


% Mean Silhouette value
sil_val = silhouette(maps,idx,'cosine');
sil_mean = mean(sil_val)

% Silhouette plot
s = mySilhouette(maps,idx);
N = size(maps,1);
K = nb_clusters;

figure;
[~,ord] = sortrows([idx s],[1 -2]);
indices = accumarray(idx(ord), 1:N, [K 1], @(x){sort(x)});
ytick = cellfun(@(ind) (min(ind)+max(ind))/2, indices);
ytickLabels = num2str((1:K)','%d');           %#'

h = barh(1:N, s(ord),'hist');
set(h, 'EdgeColor','none', 'CData',idx(ord))
set(gca, 'CLim',[1 K], 'CLimMode','manual')
set(gca, 'YDir','reverse', 'YTick',ytick, 'YTickLabel',ytickLabels)
xlabel('Silhouette Value'), ylabel('Cluster')
xlim([-1 1])

end

