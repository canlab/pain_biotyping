function multivariate_maps_all = multivariate_maps_entire(studies,nb_participants)

% Constructs the multivariate maps for the entire data set (as explained 
% in the make_multivariate_maps_entire.m function) for each one of the 
% thirteen studies contained in 'studies'.
%
% At the end, each subject is represented by one row (433 in total)

multivariate_maps_all = zeros(nb_participants,352328);

location = 1;

for i=1:numel(studies)
    multivariate_maps_all(location:location+size(studies(i).images_per_session,1)-1,:) = make_maps_multivariate_entire(studies(i));
    location = location + size(studies(i).images_per_session,1);
end

end