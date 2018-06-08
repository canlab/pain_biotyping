function all_bmrk5 = import_bmrk5()

% Imports data from bmrk5 study
% Removes subjects that do not have 60 pain ratings or 60 single-trials (or
% else the single-trials and the pain ratings are not of same size)
% Resamples into same space as all the other studies (352 328 voxels) 

bmrk = importdata('/projects/nova3832/pain_biotyping/resources/bmrk4_data.mat');

data_bmrk5 = importdata('single_trial_bmrk5_meta.mat');

bmrk5(93,1) = fmri_data;
for i=1:93
    bmrk5(i)=importdata(char(data_bmrk5.dat_obj{i}));
end


loop = [];
nb_st = 0;
for i =1:93
    if (size(data_bmrk5.ratings{i},1)==60) && (size(bmrk5(i).dat,2)==60)
        loop = append(loop,i);
        nb_st = nb_st + 60;
    end
end





all_bmrk5 = fmri_data;

dat = zeros(352328,nb_st);
Y = zeros(nb_st,1);
loc=1;
for i=loop
    i
    bmrk5(i) = resample_space(bmrk5(i),bmrk);
    dat(:,loc:loc+60-1) = bmrk5(i).dat;
    Y(loc:loc+60-1) = data_bmrk5.ratings{i};
    loc = loc + 60;
end

all_bmrk5.dat = dat;
all_bmrk5.Y = Y;


all_bmrk5.images_per_session = zeros(size(loop,2),1);
all_bmrk5.images_per_session(:) = 60;


end