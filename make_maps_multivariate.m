function [multivariate_maps1,multivariate_maps2] = make_maps_multivariate(dat)

% Constructs the multivariate maps for each subject (with PCR from 
% predict.m function)
%
% For each subject, the number of single trials is divided by 2 (using odd
% even runs). One multivariate map is constructed with the odd runs 
% (multivariate_maps1) and one is constructed with the even runs
% (multivariate_maps2).
%
% The two distinct sets of maps are then used to test whether the subjects
% belong to the same cluster in both data sets (test for reliability)



multivariate_maps1 = zeros(352328,size(dat.images_per_session,1));
multivariate_maps2 = zeros(352328,size(dat.images_per_session,1));


loc=1;
tmp_brain1 = fmri_data;
tmp_brain2 = fmri_data;

weight_objects_mv1(size(dat.images_per_session,1),1) = fmri_data;
weight_objects_mv2(size(dat.images_per_session,1),1) = fmri_data;


for i=1:size(dat.images_per_session,1)
    i
    
    ar = 1:dat.images_per_session(i);
    runs = mod(ar,2);
    tmp_dat = dat.dat(:,loc:loc+dat.images_per_session(i)-1);
    tmp_Y = dat.Y(loc:loc+dat.images_per_session(i)-1);
    
    % Odd runs
    tmp_brain1.dat = tmp_dat(:,runs==1);
    tmp_brain1.Y = tmp_Y(runs==1);
    
    [~,stats1,~] = predict(tmp_brain1,'algorithm_name','cv_pcr','nfolds',5,'error_type','mse');
    
    multivariate_maps1(:,i) = stats1.weight_obj.dat(:);
    weight_objects_mv1(i,1) = stats1.weight_obj;
    
    
    % Even runs
    tmp_brain2.dat = tmp_dat(:,runs==0);
    tmp_brain2.Y = tmp_Y(runs==0);
    
    [~,stats2,~] = predict(tmp_brain2,'algorithm_name','cv_pcr','nfolds',5,'error_type','mse');
    
    multivariate_maps2(:,i) = stats2.weight_obj.dat(:);
    weight_objects_mv2(i,1) = stats2.weight_obj;
    
    % Next subject
    loc = loc + dat.images_per_session(i);
    clear tmp_dat;
    clear tmp_Y;
    
end
multivariate_maps1 = transpose(multivariate_maps1);
multivariate_maps2 = transpose(multivariate_maps2);

end
