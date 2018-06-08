function [univariate_maps1,univariate_maps2,weight_objects_uv1,weight_objects_uv2] = make_maps_univariate(dat)

% Constructs the univariate maps for each subject (with OLS regression in 
% regress.m function)
%
% For each subject, the number of single trials is divided by 2 (using odd
% even runs). One multivariate map is constructed with the odd runs 
% (multivariate_maps1) and one is constructed with the even runs
% (multivariate_maps2).
%
% The two distinct sets of maps are then used to test whether the subjects
% belong to the same cluster in both data sets (test for reliability)

dat.Y(isnan(dat.Y))=0;


univariate_maps1 = zeros(352328,size(dat.images_per_session,1));
univariate_maps2 = zeros(352328,size(dat.images_per_session,1));


loc=1;

weight_objects_uv1(size(dat.images_per_session,1),1) = fmri_data;
weight_objects_uv2(size(dat.images_per_session,1),1) = fmri_data;

for i=1:size(dat.images_per_session,1)
    i
    
    % For odd runs
    tmp_brain1 = fmri_data;
    % For even runs
    tmp_brain2 = fmri_data;
    
    ar = 1:dat.images_per_session(i);
    runs = mod(ar,2);
    tmp_dat = dat.dat(:,loc:loc+dat.images_per_session(i)-1);
    tmp_Y = dat.Y(loc:loc+dat.images_per_session(i)-1);
    
    
    % Odd runs
    tmp_brain1.dat = tmp_dat(:,runs==1);
    tmp_brain1.Y = tmp_Y(runs==1);
    tmp_brain1.Y = zscore(tmp_brain1.Y);
    tmp_brain1.X = tmp_brain1.Y;
    
    out1 = regress(tmp_brain1,.05,'unc');
    
    out1.b = replace_empty(out1.b);
    
    univariate_maps1(:,i) = out1.b.dat(:,1);
    weight_objects_uv1(i,1) = out1.b;
    
    
    
    % Even runs
    tmp_brain2.dat = tmp_dat(:,runs==0);
    tmp_brain2.Y = tmp_Y(runs==0);
    tmp_brain2.Y = zscore(tmp_brain2.Y);
    tmp_brain2.X = tmp_brain2.Y;
    
    out2 = regress(tmp_brain2,.05,'unc');
    
    out2.b = replace_empty(out2.b);
    
    univariate_maps2(:,i) = out2.b.dat(:,1);
    weight_objects_uv2(i,1) = out2.b;

    
    
    % Next subject
    loc = loc+dat.images_per_session(i);
    clear tmp_brain1;
    clear tmp_brain2;
    clear tmp_dat;
    clear tmp_Y;
end
univariate_maps1 = transpose(univariate_maps1);
univariate_maps2 = transpose(univariate_maps2);
end
