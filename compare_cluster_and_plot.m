function [reliability_global,reliability_balanced,clt2,idx1,idx2,wrong_subjects] = compare_cluster_and_plot(idx1_old,idx2_old,coord1,coord2,C1,C2,datatype)

% Compares the clusters found in data set 1 and data set 2, with clusters
% labels contained in idx1 and idx2
%
% Computes the number of shared subjects between all the clusters (clusters 
% i in data set 1 with clusters j in data set 2) with confusion matrix.
% Associates clusters (cluster i with cluster j) with the highest number of 
% shared subjects 
% If one cluster is associated with two clusters: keeps the one with the
% highest number between the two. Then the process is started again, until
% each cluster from one data set is associated with one cluster from the
% other data set
%
% Computes the global reliability (percentage of subjects that belong to 
% the same cluster in both data sets).
%
% Computes the balanced reliability (average of the reliability found for
% each cluster individually).
%
% Replaces the cluster labels in idx2 so that the labels correspond
% 
% Displays the clusters with corresponding labels
%
% Displays the Silhouette plots with corresponding labels


nb_clusters = numel(unique(idx1_old));


clt1 = 1:nb_clusters;
clt2 = zeros(1,nb_clusters);
nb_max = zeros(1,nb_clusters);

% Confusion matrix between indixes of both data set, each bow corresponds
% to the number of participants that belong to those two clusters
nb_subjects = confusionmat(idx1_old,idx2_old);


% clt2 contains the cluster labels that corresponds to clt1 = [1 2 3 4]
for i=1:nb_clusters
    [nb_max(i),clt2(i)]=max(nb_subjects(i,:));
end

nb_subjects
clt2

% Correction if a cluster in first data set is associated with more than 
% one cluster in second data set
while (size(unique(clt2),2)~=nb_clusters)
for i=1:nb_clusters
    for j=1:nb_clusters
        if i~=j
            if clt2(i) == clt2(j)
                if nb_subjects(i,clt2(i)) >= nb_subjects(j,clt2(j))
                    nb_subjects(j,clt2(j)) = 0;
                    if nb_subjects(j) == zeros(1,nb_clusters)
                        for k=1:nb_clusters
                            if ismember(k,clt2)==0
                                clt2(j) =k;
                            end
                        end
                    else
                    [nb_max(j),clt2(j)]=max(nb_subjects(j,:));
                    end
                elseif nb_subjects(j,clt2(j)) > nb_subjects(i,clt2(i))
                    nb_subjects(i,clt2(i)) = 0;
                    if nb_subjects(i) == zeros(1,nb_clusters)
                        for l=1:nb_clusters
                            if ismember(l,clt2)==0
                                clt2(i) =l;
                            end
                        end
                    else
                    [nb_max(i),clt2(i)]=max(nb_subjects(i,:));
                    end
                end
            end
        end
        
    end
end
end

clt2

cnt = 0;

right_subjects = [];
wrong_subjects = [];

% Determines the subjects that are correctly clustered and those that are
% wrongly clustered (= do not belong to corresponding clusters based on the
% two data sets)
for i=1:min(numel(idx1_old),numel(idx2_old))
    cnt_wrong = 0;
    for j=1:nb_clusters
        if (idx1_old(i)==clt1(j)) && (idx2_old(i)==clt2(j))
            cnt = cnt + 1;
            right_subjects(end+1) = i;
        else 
            cnt_wrong = cnt_wrong + 1;
        end
    end
    if cnt_wrong == nb_clusters
        wrong_subjects(end+1) = i;
    end
end

reliability_global = (cnt/min(numel(idx1_old),numel(idx2_old)))*100;

rel_per_cluster = zeros(nb_clusters,1);
for i=1:nb_clusters
    if sum(nb_subjects(i,:))==0
        rel_per_cluster(i) = 0;
    else
        rel_per_cluster(i) = nb_subjects(clt1(i),clt2(i))/sum(nb_subjects(i,:));
    end
end

reliability_balanced = (sum(rel_per_cluster)/nb_clusters)*100;


% Replaces cluster labels in idx2
idx1 = idx1_old;
idx2 = zeros(size(idx2_old));
for i=1:numel(idx2_old)
    j = 1;
    while j<=nb_clusters
        if idx2_old(i) == clt2(j)
            idx2(i) = clt1(j);
            j = nb_clusters;
        end
        j = j+1;
    end
end

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
    


