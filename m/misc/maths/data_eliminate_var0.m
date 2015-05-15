%>@ingroup maths datasettools demo
%>@file
%>@brief Eliminates low-variance features
%>
%> Features are selected above a variance threshold.
%>
%> This file also demonstrates how objtool can be used to generate MATLAB code to create a function.
%
%> @param data Input dataset
%> @param threshold =1e-10. Variance threshold
%> @return feature-selected dataset
function ds = data_eliminate_var0(ds, threshold)

if nargin < 2 || isempty(threshold)
    threshold = 1e-10;
end;

u = fsg_test_var();
fsg_test_var01 = u;

u = cascade_fsel_grades_fsg();
u.blocks{1}.fsg = fsg_test_var01;
u.blocks{2}.type = 'threshold';
u.blocks{2}.threshold = threshold;
u.blocks{2}.sortmode = 'index';
cascade_fsel_grades_fsg01 = u;
cascade_fsel_grades_fsg01 = cascade_fsel_grades_fsg01.boot();
cascade_fsel_grades_fsg01 = cascade_fsel_grades_fsg01.train(ds);
out = cascade_fsel_grades_fsg01.use(ds);
fsel_fsg01 = out;

ds = fsel_fsg01.use(ds);