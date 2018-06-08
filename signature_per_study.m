function signature_per_study(studies,maps)

% Colors each data point given the study it came from based on their
% location in the NPS-SIIPS space

rng default;

s = size(maps,1);

tmp_brain = studies(1).get_wh_image(1);
tmp_brain.dat = transpose(maps);

nps_val_cell = apply_nps(tmp_brain);
siips_val_cell = apply_siips(tmp_brain);

nps_siips_coord(:,1) = table2array(nps_val_cell);
nps_siips_coord(:,2) = table2array(siips_val_cell);

nps_siips_coord = zscore(nps_siips_coord);

colors = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6],[0 .5 0],[0 .75 .75],[.75 0 .75],[.75 .75 0],[1 .4 .6],[.5 0 .5]};

loc = 1;
figure;
for i=1:13
    if i~=13
        scatter(nps_siips_coord(loc:loc+size(studies(i).images_per_session,1)-1,1),nps_siips_coord(loc:loc+size(studies(i).images_per_session,1)-1,2),'MarkerEdgeColor',[.25 .25 .25],'MarkerFaceColor',colors{i});
    else
        scatter(nps_siips_coord(loc:loc+size(studies(i).images_per_session,1)-2,1),nps_siips_coord(loc:loc+size(studies(i).images_per_session,1)-2,2),'MarkerEdgeColor',[.25 .25 .25],'MarkerFaceColor',colors{i});
    end
    loc = loc + size(studies(i).images_per_session,1);
    hold on
end
legend('Study 1','Study 2','Study 3','Study 4','Study 5','Study 6','Study 7','Study 8','Study 9','Study 10','Study 11','Study 12','Study 13',...
    'Location','NW');
hold off

xlabel('NPS')
ylabel('SIIPS')


end

