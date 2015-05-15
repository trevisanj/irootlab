%> @brief Dictionary: returns whether the method admits 2-class datastes only
%> @file
%> @ingroup conversion idata
%
%> @param token Example: 'lasso', 'manova', 'svm' etc
function out = get_flag_2class(token)
switch token
    case 'lasso'
        out = 1;
    otherwise
        out = 0;
end;
