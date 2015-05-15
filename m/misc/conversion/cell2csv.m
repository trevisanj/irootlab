%>@ingroup conversion string
%> @file
%> @brief Creates CSV string to be saved into CSV file
%>
%
%> @param results_table Cell of strings or numbers
%> @param deli =TAB. Delimiter
%> @return CSV-formatted string
function s = cell2csv(results_table, deli)
if nargin < 2 || isempty(deli)
    deli = sprintf('\t');
end;

chars_elim = '[]''';
lce = length(chars_elim);

% Converts all elements to str
[rows, cols] = size(results_table);
ii = 0;
for i = 1:rows
    for j = 1:cols
        t = results_table{i, j};
        
        % Eliminates undesired characters
        if ~isnumeric(t)
            stemp = t;
        else
            stemp = mat2str(t);
        end;
        for k = 1:lce
            stemp(logical(stemp == chars_elim(k))) = []; 
        end;

        results_table{i, j} = stemp;
    end;

    ii = ii+1;
    if ii == 5
        ii = 0;
    end;
end;


% Calculates total stream size
len_total = 0;
for i = 1:rows
    for j = 1:cols
        len_total = len_total+length(results_table{i, j});
    end;
end;

len_total = len_total+(cols-1)*rows+rows; % first add for \t and second one for \n

% Allocates stream
s = char(' '*ones(1, len_total));

% Writes stream
iptr = 1;
ii = 0;
for i = 1:rows
    for j = 1:cols
        ilen = length(results_table{i, j});

        if j > 1
            s(iptr) = deli;
            iptr = iptr+1;
        end;
        s(iptr:iptr+ilen-1) = results_table{i, j};
        iptr = iptr+ilen;
    end;
    
    if j > 1
        s(iptr) = sprintf('\n');
        iptr = iptr+1;
    end;
    
    ii = ii+1;
    if ii == 5
%        fprintf('%d rowsnow\n', i);
        ii = 0;
    end;
end;



