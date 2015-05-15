%> @file
%> @ingroup introspection globals assert
%> @brief Asserts the @c CLASSMAP global is present and initialized.
%> @sa classmap_compile.m

function classmap_assert()
global CLASSMAP;
if isempty(CLASSMAP)

    fn = fullfile(get_rootdir(), 'CLASSMAP.mat');
    if ~exist(fn, 'file')
        classmap_compile();
    else
        load(fn);
    end;
end;
