%> @ingroup misc introspection
%> @file
%>@brief Adds all folders to the MATLAB path. This script needs to be run from the IRootLab root folder.

d = dir('*');
n = {d.name};
b = [d.isdir];
n(~b) = [];
n(strcmp(n, '.') | strcmp(n, '..') | strcmp(n, '.svn')) = [];

p = pwd();

for i = 1:numel(n)
    addtopath(fullfile(p, n{i}));
end;

classmap_assert();
colors_markers();
setup_load();

fprintf(['\n', ...
         '*********************************************************************************************************\n']);
fprintf([get_credits, '\n', get_welcome(), '\n', get_cite(), '\n']);
global HSC; HSC = 1;

clear d n b p i;