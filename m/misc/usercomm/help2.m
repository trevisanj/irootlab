%> @file
%>@ingroup usercomm
%> @brief Calls browser with Doxygen help for prefix
%>
%> MATLAB web browser is absolutely crap! Doxygen 1.7.4 does not use frames anymore and has lots of JavaScript when its advanced options are set.
%> However, even  turning all JavaScript off, MATLAB web browser still fails to produce a decent rendering of Doxygen help.
%>
%> Therefore, will open help in external browser! Windows users shouldn't have any problem. I had a problem in
%> Linux with starting Firefox, but using NetSurf it worked fine (although NetSurf does not support JavaScript).
%>
%> MATLAB external browser is configurable at File->Preferences...->Web
function help2(prefix)

path_assert();
global PATH;

flag_default = 0;
url = [];

if nargin < 1 || isempty(prefix)
    flag_default = 1;
else
    [~, prefix] = fileparts(prefix);
    prefix = strrep(prefix, '_', '__'); % Doxygen replaces all underscores with double underscores

    url = [PATH.doc, '/html/', prefix, '_8m.html'];
    
% %     dd = dir(fullfile(PATH.doc, 'html', [prefix '*.html']));
% %     if ~isempty(dd)
% %         url = fullfile(PATH.doc, 'html', dd(1).name);
% %     %     try
% %     %         web(url, '-browser');
% % 
% %     %         irverbose('Opened help page in system web browser', 3);
% %     %     catch ME
% %     %         irverbose('Could not launch system web browser, using MATLAB browser', 3);
% %     %         irverbose('Could not launch system web browser, using MATLAB browser', 3);
% %     %         web(url);
% %     %     end;
% %     else
% %         answer = questdlg(sprintf('No help found for ''%s''. Would you like to open IRoot main help page?', prefix), 'Help', 'Yes', 'No', 'Yes');
% %         switch (answer)
% %             case 'Yes'
% %                 flag_default = 1;
% %         end;
% %     end;
end;

if flag_default
    url = [PATH.doc, '/html/index.html'];
end;

if ~isempty(url)
    stat = web(url, '-browser', '-new');
    if stat == 0
        irverbose(['Launched URL "', url, '" in external browser', 0]);
    else
        inputdlg('Couldn''t start web browser. Please manually paste the following URL into your web browser:', 'Error', 1, {url});
    end;
        
%     web(url, '-new');
end;
