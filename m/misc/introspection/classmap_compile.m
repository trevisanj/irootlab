%> @file
%> @ingroup introspection globals
%> @brief Creates the @c CLASSMAP global and saves it into the "misc" directory
%> @sa classmap_assert.m

function classmap_compile()
global CLASSMAP;
% Uses temp variable to make sure CLASSMAP will be assigned only if map built is successful
temp = classmap();
temp.build('irdata');
temp.build('block');
temp.build('sgs');
temp.build('fsg');
temp.build('peakdetector');
temp.build('irlog');
temp.build('vectorcomp');
temp.build('soitem');
CLASSMAP = temp;


fn = fullfile(get_rootdir(), 'CLASSMAP.mat');
save(fn, 'CLASSMAP');
