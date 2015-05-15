%> @ingroup conversion classlabelsgroup string
%> @file
%> @brief Class labels hierarchy resolver.
%>
%> This function parses a list of multi-level class labels, essentially finding the individual labels between the 
%> '|' separators.
%>
%> It also mounts new class labels and gives their corresponding new class numbers, if the 'new_hierarchy' input is
%> passed.
%>
%> Everything is returned in a 2D cell that contains one row for each class label. The meanings of the cell columns are 
%> as follows:
%>
%> @arg Column 1: original class numbers, actually just a zero-based increasing counter
%> @arg Column 2: the original class labels, in the same order as in 'classlabels'
%> @arg Column 3: new class labels according to the class levels to be retained
%> @arg Column 4: new class numbers according to new hierarchy
%> @arg Columns 5, 6, 7 ...: parsed individual labels per level. The number of columns in the cell will be thus 4+no_levels
%>
%> <h3>Example:</h3>
%> @verbatim
%> >> c = {'A|1|T', 'A|1|F', 'A|2|T', 'A|2|F', 'A|3|T', 'A|3|F', 'B|1|T', 'B|1|F'};
%> >> cc = classlabels2cell(c, [1, 3])
%> 
%> cc = 
%> 
%>     [0]    'A|1|T'    'A|T'    [1]    'A'    '1'    'T'
%>     [1]    'A|1|F'    'A|F'    [0]    'A'    '1'    'F'
%>     [2]    'A|2|T'    'A|T'    [1]    'A'    '2'    'T'
%>     [3]    'A|2|F'    'A|F'    [0]    'A'    '2'    'F'
%>     [4]    'A|3|T'    'A|T'    [1]    'A'    '3'    'T'
%>     [5]    'A|3|F'    'A|F'    [0]    'A'    '3'    'F'
%>     [6]    'B|1|T'    'B|T'    [3]    'B'    '1'    'T'
%>     [7]    'B|1|F'    'B|F'    [2]    'B'    '1'    'F'
%> @endverbatim
%>
%> @sa cell2classlabels.m
%
%> @param classlabels
%> @param new_hierarchy =[]. New hierarchy. 0 means "none"; [] means "all"
%> @return \em cc
function out = classlabels2cell(classlabels, new_hierarchy)

no = length(classlabels);
no_levels = 0;
for i = 1:no
    no_levels = max(no_levels, sum(classlabels{i} == '|')+1);
end;

flag_new_hierarchy = exist('new_hierarchy', 'var') && ~isempty(new_hierarchy);
if ~flag_new_hierarchy
    new_hierarchy = 1:no_levels;
end;

if max(new_hierarchy) > no_levels
    irerror(sprintf('Class labels only have %d level(s)!', no_levels));
end;

new_hierarchy(new_hierarchy == 0) = [];


NO_COLS_FIXED = 4;
out = cell(no, no_levels+NO_COLS_FIXED);

c = [];
for i = 1:no
    out{i, 1} = i-1; % old class index
    out{i, 2} = classlabels{i};
    
    % properties to be filled out later
    out{i, 3} = ''; % name_modified
    out{i, 4} = -1; % new class index

    c = regexp(classlabels{i}, '\|', 'split');
    out(i, NO_COLS_FIXED+1:NO_COLS_FIXED+length(c)) = c;
end;

% Fills gaps with empty spaces. TODO there may be an error here with this "length(c)"
%{
for j = NO_COLS_FIXED+1:NO_COLS_FIXED+length(c)
    len_max = 0;
    for i = 1:no
        len_max = max(len_max, length(out{i, j}));
    end;
    spaces = ones(1, len_max)*' ';
    
    for i = 1:no
        out{i, j} = [out{i, j} spaces(1:len_max-length(out{i, j}))];
    end;
end;
%}


for i = 1:no
    out{i, 3} = cell2classlabel(out(i, new_hierarchy+NO_COLS_FIXED));
end;

% Sort in the new hierarchy order in order to count and assign new class indexes
out = sortrows(out, 3);

s_cmp = '@!&*(#&*(%'; % Something random highly unlikely to be used as a class label by the user
idx = -1;
for i = 1:no
    if ~strcmp(s_cmp, out{i, 3})
        idx = idx+1;
        s_cmp = out{i, 3};
    end;
    out{i, 4} = idx;
end;

out = sortrows(out, 1);
    

% Last pass will renumber the new class numbers to retain the original order
classnew = -1;
classnow = -1;
already = [];
for i = 1:no
%     if out{i, 4} ~= classnow
        idxclass = find(already == out{i, 4});
        if ~isempty(idxclass)
            out{i, 4} = idxclass-1;
        else
            classnow = out{i, 4};
            classnew = classnew+1;
            out{i, 4} = classnew;
            already = [already, classnow];
        end;
%     end;
%     out{i, 4} = idx;
end;




    
%>@cond
%---------------------------------------------------
function cl = cell2classlabel(c)
cl = '';
for i = 1:length(c)
    if i > 1
        cl = [cl '|'];
    end;
    cl = [cl c{i}];
end;
%>@endcond
