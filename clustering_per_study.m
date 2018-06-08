function clustering_per_study(studies,maps)

% Colors data points given the study they came from
% First one is done on the signatures responses space
% Second one is done on the entire maps, visualized in 3D with t-SNE

maps(isnan(maps))=0;

figure(1);
signature_per_study(studies,maps);
title('Signatures responses');

figure(2);
entire_maps_per_study(studies,maps);
title('t-SNE generated 3D maps');

end