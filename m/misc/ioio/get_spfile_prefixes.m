% This function was created to centralize the information about single-spectrum types
function P = get_spfile_prefixes()
P = {'pir', 'opus', 'wire', 'mary', 'diane', 'bwspeccsv'};

% Assertion
P2 = get_spfile_descriptions();
if length(P) ~= length(P2)
    irerror('get_spfile_descriptions.m out of sync with get_spfile_prefixes.m');
end;