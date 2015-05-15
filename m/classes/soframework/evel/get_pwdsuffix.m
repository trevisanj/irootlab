%> Invokes pwd() and returns the string right its last underscore (if any)
%>
%> @param flag_whole =0
function a = get_pwdsuffix(flag_whole)

if nargin < 1 || isempty(flag_whole)
    flag_whole = 0;
end;

a = pwd();

slashpos = find(a == filesep());

if ~isempty(slashpos)
    a = a((slashpos(end)+1):end);
end;

if ~flag_whole
    underpos = find(a == '_');

    if ~isempty(underpos)
        a = a((underpos(end)+1):end);
    end;
end;

if isempty(a)
    irerror(['Failure, sorry. FYI, pwd() is ', pwd()]);
end;
