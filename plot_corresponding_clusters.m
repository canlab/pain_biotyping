function [idx1,idx2] = plot_corresponding_clusters(idx1_old,idx2_old,coord1,coord2,C1,C2,datatype)

% Finds corresponding clusters in both data sets (idxN = indexes of objects
% in data set N) and replaces the indexes in idx2 so that they both have
% the same cluster labels
% Displays the clusters for both maps (now they are corresponding)
%
% Displays the Silhouette plots for both maps
%
%
% Datatype = 'sign','entire','pca' or 'buck'

nb_clusters = numel(unique(idx1_old));

clusters_dataset1 = 1:4;
[~,~,clusters_dataset2] = compare_cluster(idx1_old,idx2_old);

clusters_dataset2

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

corr(idx2_old,idx2)

colors = {'b','r','g','y','k',[.5 .6 .7],[.8 .2 .6],[0 .5 0],[0 .75 .75],[.75 0 .75],[.75 .75 0],[1 .4 .6],[.5 0 .5]};


% Plot clusters

% Signatures responses
if strcmp(datatype,'sign')
    
    figure;
    for i = 1:nb_clusters
        scatter(coord1(idx1==i,1),coord1(idx1==i,2),12,colors{i},'filled');
        hold on
    end
    hold on
    plot(C1(:,1),C1(:,2),'kx',...
        'MarkerSize',15,'LineWidth',3);
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
        'Location','NW');
    hold off
    xlabel('NPS');
    ylabel('SIIPS');
    
    figure;
    for i = 1:nb_clusters
        scatter(coord2(idx2==i,1),coord2(idx2==i,2),12,colors{i},'filled');
        hold on
    end
    hold on
    plot(C2(:,1),C2(:,2),'kx',...
        'MarkerSize',15,'LineWidth',3);
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids',...
        'Location','NW');
    hold off
    xlabel('NPS');
    ylabel('SIIPS');
    
% Entire maps, or PCA reduced maps, or canonical networks
elseif (strcmp(datatype,'entire')) || (strcmp(datatype,'pca')) || (strcmp(datatype,'buck'))
    figure;
    for i = 1:nb_clusters
        scatter(coord1(idx1==i,1),coord1(idx1==i,2),12,colors{i},'filled');
        hold on
    end
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
        'Location','NW');
    xlabel('x')
    ylabel('y')
    
    figure;
    for i = 1:nb_clusters
        scatter(coord2(idx2==i,1),coord2(idx2==i,2),12,colors{i},'filled');
        hold on
    end
    legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
        'Location','NW');
    xlabel('x')
    ylabel('y')
end



% Silhouette plots
    s1 = mySilhouette(coord1,idx1);
    N = size(coord1,1);
    K = nb_clusters;

    figure;
    [~,ord] = sortrows([idx1 s1],[1 -2]);
    indices = accumarray(idx1(ord), 1:N, [K 1], @(x){sort(x)});
    ytick = cellfun(@(ind) (min(ind)+max(ind))/2, indices);
    ytickLabels = num2str((1:K)','%d');           %#'

    h = barh(1:N, s1(ord),'hist');
    set(h, 'EdgeColor','none', 'CData',idx1(ord))
    set(gca, 'CLim',[1 K], 'CLimMode','manual')
    set(gca, 'YDir','reverse', 'YTick',ytick, 'YTickLabel',ytickLabels)
    xlabel('Silhouette Value'), ylabel('Cluster')
    xlim([-1 1])
    
    
    s2 = mySilhouette(coord2,idx2);
    N = size(coord1,1);
    K = nb_clusters;

    figure;
    [~,ord] = sortrows([idx2 s2],[1 -2]);
    indices = accumarray(idx2(ord), 1:N, [K 1], @(x){sort(x)});
    ytick = cellfun(@(ind) (min(ind)+max(ind))/2, indices);
    ytickLabels = num2str((1:K)','%d');           %#'

    h = barh(1:N, s2(ord),'hist');
    set(h, 'EdgeColor','none', 'CData',idx2(ord))
    set(gca, 'CLim',[1 K], 'CLimMode','manual')
    set(gca, 'YDir','reverse', 'YTick',ytick, 'YTickLabel',ytickLabels)
    xlabel('Silhouette Value'), ylabel('Cluster')
    xlim([-1 1])
    
    
end
    
    
    
    
    
    
    
    
