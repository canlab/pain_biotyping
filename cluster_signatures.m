function [idx,C,nps_siips_coord,sil_mean] = cluster_signatures(maps,nb_clusters)

% Searches for nb_clusters clusters within the signatures responses (NPS 
% and SIIPS) applied to maps.
%
% Plots the results in a two-dimensional space 
%
% Displays the Silhouette plot
%
% Returns the clusters labels (idx), the positions of the centroids (C),
% the signatures responses (nps_siips_coord) and the mean Silhouette value
% of the clusters (sil_mean)


rng default;
% For reproducibility

s = size(maps,1);

tmp_brain = fmri_data;
tmp_brain.dat = transpose(maps);

nps_val_cell = apply_nps(tmp_brain);
siips_val_cell = apply_siips(tmp_brain);

nps_siips_coord(:,1) = table2array(nps_val_cell);
nps_siips_coord(:,2) = table2array(siips_val_cell);

nps_siips_coord = zscore(nps_siips_coord);


opts = statset('Display','Final');

colors = {'b','r','g','y','k',[.5 .6 .7],[.8 .2 .6],[0 .5 0],[0 .75 .75],[.75 0 .75],[.75 .75 0],[1 .4 .6],[.5 0 .5]};

[idx,C] = kmedoids(nps_siips_coord,nb_clusters,'Distance','cosine',...
    'Replicates',5,'Options',opts);


% Plot of the clusters on a two-dimensional space
figure;
for i = 1:nb_clusters
    scatter(nps_siips_coord(idx==i,1),nps_siips_coord(idx==i,2),12,colors{i},'filled');
    hold on
end
hold on
plot(C(:,1),C(:,2),'kx',...
    'MarkerSize',15,'LineWidth',3);

if nb_clusters==2
    legend('Cluster 1','Cluster 2','Centroids',...
    'Location','NW');
elseif nb_clusters==3
    legend('Cluster 1','Cluster 2','Cluster 3','Centroids',...
    'Location','NW');
elseif nb_clusters==4
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
    'Location','NW');
elseif nb_clusters==6
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6','Centroids',...
    'Location','NW');
elseif nb_clusters==10
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Cluster 6','Cluster 7','Cluster 8','Cluster 9','Cluster 10','Centroids',...
    'Location','NW');
end

hold off
xlabel('NPS');
ylabel('SIIPS');

% Mean Silhouette value
sil_val = silhouette(nps_siips_coord,idx,'cosine');
sil_mean = mean(sil_val)

% Silhouette plot
s = mySilhouette(nps_siips_coord,idx);
N = size(nps_siips_coord,1);
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


