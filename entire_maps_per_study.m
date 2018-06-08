function entire_maps_per_study(studies,maps)

% Colors each data point given the study it came from
% Visualization in 3D using t-SNE


rng default;
% For reproducibility

no_dims = 3;
initial_dims = 100;
perplexity = 50;

mapped_maps = tsne(maps,[],no_dims,initial_dims,perplexity);

colors = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6],[0 .5 0],[0 .75 .75],[.75 0 .75],[.75 .75 0],[1 .4 .6],[.5 0 .5]};

loc = 1;
figure;
for i=1:13
    if i~=13
        scatter3(mapped_maps(loc:loc+size(studies(i).images_per_session,1)-1,1),mapped_maps(loc:loc+size(studies(i).images_per_session,1)-1,2),mapped_maps(loc:loc+size(studies(i).images_per_session,1)-1,3),'MarkerEdgeColor',[.25 .25 .25],'MarkerFaceColor',colors{i});
    else
        scatter3(mapped_maps(loc:loc+size(studies(i).images_per_session,1)-2,1),mapped_maps(loc:loc+size(studies(i).images_per_session,1)-2,2),mapped_maps(loc:loc+size(studies(i).images_per_session,1)-2,3),'MarkerEdgeColor',[.25 .25 .25],'MarkerFaceColor',colors{i});
    end
        loc = loc + size(studies(i).images_per_session,1);
    hold on
end
legend('Study 1','Study 2','Study 3','Study 4','Study 5','Study 6','Study 7','Study 8','Study 9','Study 10','Study 11','Study 12','Study 13',...
    'Location','NW');
hold off



end

