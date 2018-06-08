function avg_map = mean_map(maps)

avg_map = fmri_data;
avg_map.dat = transpose(mean(maps,'omitnan'));

orthviews(avg_map);

end