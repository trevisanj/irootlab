%
% JT 20161218 -- Opens Wire (2016?) format and returns a matrix [nf]x[2]
%
% First columns are wavenumbers and second columns are intensities
%
%
function M = mary2matrix(filename)
h = fopen(filename, 'r');
n = 1;
M = zeros(n, 2);
try
    i = 0;
    while 1
        s = fgets(h);
        if s == -1
            break;  % EOF
        end;
        if length(s) == 2
            continue;  % blank line
        end;
        if s(1) == '#'
            continue;
        end;
        
        i = i+1;
        if i > n
            n = n*2;
            M(n, 1) = 0;  % extends matrix
        end;
        M(i, :) = sscanf(s, '%f');
    end;
    
    if n > i
        M = M(1:i, :);
    end;  
   
    fclose(h);
catch ME
    fclose(h);
    rethrow(ME);
end;