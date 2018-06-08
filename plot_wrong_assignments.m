function plot_wrong_assignments(idx1,idx2,coord1,coord2,wrong_subjects,datatype)

% Plots the clusters in color codes corresponding to cluster labels and
% adds the subjects that do not belong to the same cluster in data set 1
% and data set 2 (black crosses)

figure;
scatter(coord1(idx1==1,1),coord1(idx1==1,2),20,'b','filled');
hold on
scatter(coord1(idx1==2,1),coord1(idx1==2,2),20,'r','filled');
hold on
scatter(coord1(idx1==3,1),coord1(idx1==3,2),20,'g','filled');
hold on
scatter(coord1(idx1==4,1),coord1(idx1==4,2),20,'y','filled');
% plot(C1(:,1),C1(:,2),'kx',...
%     'MarkerSize',15,'LineWidth',3);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
    'Location','NW');
hold on

plot(coord1(wrong_subjects,1),coord1(wrong_subjects,2),'k*','MarkerSize',6);

if strcmp(datatype,'sign')
    xlabel('NPS')
    ylabel('SIIPS')
elseif (strcmp(datatype,'entire')) || (strcmp(datatype,'pca')) || (strcmp(datatype,'buck'))
    xlabel('x')
    ylabel('y')
end


figure;

scatter(coord2(idx2==1,1),coord2(idx2==1,2),20,'b','filled');
hold on
scatter(coord2(idx2==2,1),coord2(idx2==2,2),20,'r','filled');
hold on
scatter(coord2(idx2==3,1),coord2(idx2==3,2),20,'g','filled');
hold on
scatter(coord2(idx2==4,1),coord2(idx2==4,2),20,'y','filled');
% plot(C2(:,1),C2(:,2),'kx',...
%     'MarkerSize',15,'LineWidth',3);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4',...
    'Location','NW');
hold on

plot(coord2(wrong_subjects,1),coord2(wrong_subjects,2),'k*','MarkerSize',6);

if strcmp(datatype,'sign')
    xlabel('NPS')
    ylabel('SIIPS')
elseif (strcmp(datatype,'entire')) || (strcmp(datatype,'pca')) || (strcmp(datatype,'buck'))
    xlabel('x')
    ylabel('y')
end

end
