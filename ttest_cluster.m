function ttest_cluster(maps_cluster)

% Performs a voxelwise t-test on maps_cluster (which corresponds to the
% cluster centroid = average maps of the subjects in this cluster)
%
% Then, it is thresholded with FDR and alpha = 0.05, and displayed as a
% montage plot

tmp_brain = fmri_data;

tmp_brain.dat = maps_cluster;

ttest_cluster = ttest(tmp_brain);

ttest_cluster = threshold(ttest_cluster, .05, 'fdr');
create_figure('montage'); 
montage(ttest_cluster);

end