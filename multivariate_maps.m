function [multivariate_maps_all1,multivariate_maps_all2] = multivariate_maps(studies,nb_participants)

% Constructs the multivariate maps for two distinct data sets (as explained 
% in the make_multivariate_maps.m function) for each one of the thirteen 
% studies contained in 'studies'.
%
% At the end, each subject is represented by one row (433 in total)

multivariate_maps_all1 = zeros(nb_participants,352328);
multivariate_maps_all2 = zeros(nb_participants,352328);

location = 1;

for i=1:numel(studies)
    [multivariate_maps_all1(location:location+size(studies(i).images_per_session,1)-1,:),multivariate_maps_all2(location:location+size(studies(i).images_per_session,1)-1,:)] = make_maps_multivariate(studies(i),nb_participants);
    location = location + size(studies(i).images_per_session,1);
end

end