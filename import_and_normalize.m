function [studies,nb_participants,nb_single_trials_tot] = import_and_normalize(studies)

% Constructs an array of fmri_data objects, each element corresponds to one
% study (13 in total)
%
% Normalizes the .dat and .Y with the study grand voxel mean value and
% standard deviation
%
% Computes the total number of participants and single trials

studies(13,1) = fmri_data;
studies(1,1) = importdata('/projects/nova3832/pain_biotyping/resources/bmrk4_data.mat');
studies(2,1) = importdata('/projects/nova3832/pain_biotyping/resources/ie2_data.mat');
studies(3,1) = importdata('/projects/nova3832/pain_biotyping/resources/ie_data.mat');
studies(4,1) = importdata('/projects/nova3832/pain_biotyping/resources/ilcp_wani_data.mat');
studies(5,1) = importdata('/projects/nova3832/pain_biotyping/resources/nsf_data.mat');
studies(6,1) = importdata('/projects/nova3832/pain_biotyping/resources/remi_data.mat');
studies(7,1) = importdata('/projects/nova3832/pain_biotyping/resources/romantic_pain_data.mat');
studies(8,1) = importdata('/projects/nova3832/pain_biotyping/resources/scebl_data.mat');
studies(9,1) = importdata('/projects/nova3832/pain_biotyping/resources/stephan_data.mat');
studies(10,1) = importdata('/projects/nova3832/pain_biotyping/resources/bmrk3_data.mat');
studies(11,1) = importdata('/projects/nova3832/pain_biotyping/resources/exp_data.mat');
studies(12,1) = importdata('/projects/nova3832/pain_biotyping/resources/levoderm_data.mat');
studies(13,1) = import_bmrk5;

for i=1:numel(studies)
    mu = mean(studies(i).dat(:),'omitnan');
    sd = std(studies(i).dat(:),'omitnan');
    studies(i).dat = (studies(i).dat - mu)./sd;

    mu2 = mean(studies(i).Y(:),'omitnan');
    sd2 = std(studies(i).Y(:),'omitnan');
    studies(i).Y = (studies(i).Y - mu2)./sd2;
end

nb_participants=0;

for i=1:numel(studies)
    nb_participants = nb_participants + size(studies(i).images_per_session,1);
end

nb_single_trials_tot = 0;

for i=1:numel(studies)
    nb_single_trials_tot = nb_single_trials_tot + size(studies(i).Y,1);
end

end