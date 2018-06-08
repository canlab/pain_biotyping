function optimal_number_clusters(maps1,maps2)

% Determines the optimal number of clusters based on two measurements:
% the balanced reliability and the mean Silhouette value.
%
% For each number to be tested (in number_to_test), the
% cluster_signatures.m and the cluster_maps_dim_reduction.m are applied for
% the two data sets, then they are compared and we keep the balanced
% accuracy and the mean Silhouette value.
%
% At the end, plots the two measurements as a function on the number of
% clusters in order to find the maximum

number_to_test = [2 3 4 5 6 7 8 9 10 11 12 13 14 15];

rel_sign = zeros(1,size(number_to_test,2));
rel_maps = zeros(1,size(number_to_test,2));

sil_sign = zeros(1,size(number_to_test,2));
sil_maps = zeros(1,size(number_to_test,2));

j = 1;
k = 1;

% Signatures responses
for i=number_to_test
    [idx1,~,~,sil1_sign] = cluster_signatures(maps1,i);
    [idx2,~,~,sil2_sign] = cluster_signatures(maps2,i);
    [~,rel_sign(1,j)] = compare_cluster(idx1,idx2);
    sil_sign(1,j) = (sil1_sign+sil2_sign)/2;
    j = j + 1;
end

% PCA reduced maps
for i=number_to_test
    [idx1,~,~,sil1_maps] = cluster_maps_dim_reduction(maps1,i,2);
    [idx2,~,~,sil2_maps] = cluster_maps_dim_reduction(maps2,i,2);
    [~,rel_maps(1,k)] = compare_cluster(idx1,idx2);
    sil_maps(1,k) = (sil1_maps+sil2_maps)/2;
    k = k + 1;
end

% Balanced reliability
figure;
plot(number_to_test,rel_sign,'LineWidth',2,'Color',[.8 .8 .2]);
hold on
plot(number_to_test,rel_maps,'LineWidth',2,'Color',[.8 .8 1]);
legend('Signatures','PCA reduced maps');
ylabel('Balanced accuracy');
xlabel('Number of clusters');
hold off

% Mean Silhouette value
figure;
plot(number_to_test,sil_sign,'LineWidth',2,'Color',[.8 .8 .2]);
hold on
plot(number_to_test,sil_maps,'LineWidth',2,'Color',[.8 .8 1]);
legend('Signatures','PCA reduced maps');
ylabel('Mean Silhouette value');
xlabel('Number of clusters');
hold off

figure;
plot(number_to_test,sil_sign,'LineWidth',2,'Color',[.8 .8 .2]);
ylabel('Mean Silhouette value');
xlabel('Number of clusters');
title('Signatures');

figure;
plot(number_to_test,sil_maps,'LineWidth',2,'Color',[.8 .8 1]);
ylabel('Mean Silhouette value');
xlabel('Number of clusters');
title('PCA reduced maps');

end