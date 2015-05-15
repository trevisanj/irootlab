%>@ingroup idata
%>@file
%>@brief Chemical-wavenumber correspondence
%> 
%> Returns a table with substance names, peak centres and closest indexes in
%> @c x, if @c x is provided.
%
%> @param x (optional)
%> @param flag_table =0
function Z = peak_db(x, flag_table)


if ~exist('flag_table', 'var')
    flag_table = 0;
end;

Z.names = {'lipid',
           'amide I', 
           'amide II', 
           'proteins?', 
           'proteins', 
           'COO- symmetric stretching vibrations of fatty acids and amino acid', 
           'amide III', 
           'asymmetric phosphate', 
           'carbohidrate', 
           'C-O stretch (nu CO)'
           'symmetric phosphate', 
           'glycogen',
           'protein phosphorylation'};
Z.centres = [
    1750, 
    1635, 
    1531, 
    1454, 
    1425, 
    1396, 
    1260, 
    1225,
    1155, 
    1140, 
    1080, 
    1030, 
     970];

if exist('x')
    no = length(Z.centres);
    no_x = length(x);
    Z.indexes = zeros(1, no);
    
    for i = 1:no
        for j = 1:no_x
            if Z.centres(i) > x(j)
               
                % Checks which point is closest, if current or last one.
                if j == 1
                    Z.indexes(i) = j;
                elseif Z.centres(i)-x(j) < x(j-1)-Z.centres(i)
                    Z.indexes(i) = j;
                else
                    Z.indexes(i) = j-1;
                end;
                break;
            end;
        end;
        if Z.indexes(i) == 0
            Z.indexes(i) = no_x;
        end;
    end;
end;


