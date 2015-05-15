%>@brief Loads sample data by file name
%>@file
%>@ingroup ioio
%
%> @param filename
%> @param flag_workspace =0. Whether to drop a "ds<nn>" variable in base workspace
%> @return ds
function ds = load_sampledata(filename, flag_workspace)

if nargin < 2 || isempty(flag_workspace)
    flag_workspace = 0;
end;

ds = dataloader.load_dataset(fullfile(get_rootdir(), 'demo', 'sampledata', filename));

if flag_workspace
    name_new = find_varname('ds');
    global o; %#ok<TLEV>
    o = ds;
    evalin('base', sprintf('global o; %s = o;', name_new));
    clear o;
    irverbose(sprintf('Created variable "%s" in base workspace', name_new), 2);
end;