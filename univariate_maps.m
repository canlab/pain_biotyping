function [univariate_maps_all1,univariate_maps_all2,weight_obj_uv1,weight_obj_uv2] = univariate_maps(studies,nb_participants)

% Constructs the univariate maps for two distinct data sets (as explained 
% in the make_univariate_maps.m function) for each one of the thirteen 
% studies contained in 'studies'.
%
% At the end, each subject is represented by one row (433 in total)

univariate_maps_all1 = zeros(nb_participants,352328);
univariate_maps_all2 = zeros(nb_participants,352328);

weight_obj_uv1(nb_participants,1) = fmri_data;
weight_obj_uv2(nb_participants,1) = fmri_data;

location = 1;

for i=1:13
    [univariate_maps_all1(location:location+size(studies(i).images_per_session,1)-1,:),univariate_maps_all2(location:location+size(studies(i).images_per_session,1)-1,:),weight_obj_uv1(location:location+size(studies(i).images_per_session,1)-1,1),weight_obj_uv2(location:location+size(studies(i).images_per_session,1)-1,1)] = make_maps_univariate(studies(i));
    location = location + size(studies(i).images_per_session,1);
end

end