% 3rdpass - maybe stick the formats here as mode 2 - much easier
%> This function is sort of a dictionary
%> @param mode =0
%>   @arg 0 - returns string
%>   @arg 1 - returns a "flag_lower_is_better"
%>
function s = labeldict(name, mode)

if nargin < 2 || isempty(mode)
    mode = 0;
end;

switch mode
    case 0
        switch name
            case 'rates'
                s = 'Classification rate (%)';
            case 'times1'
                s = 'Training time (seconds)';
            case 'times2'
                s = 'Test time (seconds)';
            case 'times3'
                s = 'Training+test time (seconds)';
            case 'no_rules'
                s = 'Number of rules';
            case 'no_svs'
                s = 'Number of support vectors';
            otherwise
                s = replace_underscores(sprintf('#%s#', name));
        end;
    case 1
        switch name
            case 'rates'
                s = 0;
            case 'times1'
                s = 1;
            case 'times2'
                s = 1;
            case 'times3'
                s = 1;
            case 'no_rules'
                s = 1;
            case 'no_svs'
                s = 1;
            otherwise
                s = 0; % Default is higher is better
%                 irerror(sprintf('Don''t know flag_lower_is_better for "%s"', name));
        end;
end;
