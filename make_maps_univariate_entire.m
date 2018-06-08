function univariate_maps_entire = make_maps_univariate_entire(dat)

% Constructs the univariate maps for each subject (with OLS regression in 
% regress.m function)

dat.Y(isnan(dat.Y))=0;

univariate_maps_entire = zeros(352328,size(dat.images_per_session,1));

loc=1;

weight_objects(size(dat.images_per_session,1),1) = fmri_data;

for i=1:size(dat.images_per_session,1)
    i
    
    tmp_brain = fmri_data;
    
    tmp_brain.dat = dat.dat(:,loc:loc+dat.images_per_session(i)-1);
    tmp_brain.Y = dat.Y(loc:loc+dat.images_per_session(i)-1);
    
    tmp_brain.Y = zscore(tmp_brain.Y);
    tmp_brain.X = tmp_brain.Y;
    
    out = regress(tmp_brain,.05,'unc');
    
    out.b = replace_empty(out.b);
    
    univariate_maps_entire(:,i) = out.b.dat(:,1);
    weight_objects(i,1) = out.b;
    
    
    
    % Next patient
    loc = loc+dat.images_per_session(i);

end
univariate_maps_entire = transpose(univariate_maps_entire);
end
