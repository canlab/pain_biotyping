function maps_summarized = summarize_weights_bucknerlab(maps)

% Creates maps_summarized that correspond to the original weight maps
% (maps) which are summarized into 7 canonical networks (Bucknerlab)

names = load('Bucknerlab_7clusters_SPMAnat_Other_combined_regionnames.mat');
img = which('rBucknerlab_7clusters_SPMAnat_Other_combined.img');

mask_tot = fmri_data(img, [], 'noverbose');  % loads image with integer coding of networks

networknames = names.rnames(1:7);
k = length(networknames);

newmaskdat = zeros(size(mask_tot.dat, 1), k);

for i = 1:k  % breaks up into one map per image/network
    wh = mask_tot.dat == i;
    nvox(1, i) = sum(wh);
    newmaskdat(:, i) = double(wh);
end

mask_tot.dat = newmaskdat;

mask_regions(7,1) = fmri_data;
for i=1:7
    mask_regions(i,1).dat(:) = mask_tot.dat(:,i);
end


tmp_brain = fmri_data;
tmp_brain_mask = fmri_data;

maps_summarized = zeros(size(maps,1),7);
for i =1:size(maps,1)
    
    tmp_brain.dat = transpose(maps(i,:));
    for j = 1:7
    tmp_brain_mask = apply_mask(tmp_brain,mask_regions(j));
    maps_summarized(i,j) = mean(tmp_brain_mask.dat);
    end
end

