function multivariate_maps_entire = make_maps_multivariate_entire(dat)

% Constructs the multivariate maps for each subject (with PCR from 
% predict.m function)



multivariate_maps_entire = zeros(352328,size(dat.images_per_session,1));


loc=1;
tmp_brain = fmri_data;


weight_objects(size(dat.images_per_session,1),1) = fmri_data;


for i=1:size(dat.images_per_session,1)
    i
   
    tmp_brain.dat = dat.dat(:,loc:loc+dat.images_per_session(i)-1);
    tmp_brain.Y = dat.Y(loc:loc+dat.images_per_session(i)-1);
    
    
    [~,stats,~] = predict(tmp_brain,'algorithm_name','cv_pcr','nfolds',5,'error_type','mse');

    multivariate_maps_entire(:,i) = stats.weight_obj.dat(:);
    weight_objects(i,1) = stats.weight_obj;
  
    
    % Next patient
    loc = loc + dat.images_per_session(i);
    
end
multivariate_maps_entire = transpose(multivariate_maps_entire);

end
