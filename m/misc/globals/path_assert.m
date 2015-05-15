%> @ingroup globals setupgroup assert
%> @file
%> @brief Asserts the @c PATH global is present and initialized.
%>
%> Please check the source code for reference.
function path_assert()
global PATH;
if isempty(PATH)
    % Default load path in objtool and datatool
    PATH.data_load = '.';
    % Default save path in objtool and datatool
    PATH.data_save = '.';
    % Default load path in mergetool
    PATH.data_spectra = '.';
    
    % default documentation path
%     path = get_rootdir();
%     PATH.doc = fullfile(path, 'doc');
    PATH.doc = 'http://bioph.lancs.ac.uk/irootdoc';
end;
