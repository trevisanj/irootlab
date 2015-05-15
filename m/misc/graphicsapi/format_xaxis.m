%>@ingroup graphicsapi
%>@file
%>@brief Format x-axis to nice range and reversed
%
%> @param par May be either a vector or an irdata object. If the former, takes the values at the extremities of the vector to use as the x-axis limits; if the latter, takes the x-axis limits from the @a fea_x property and uses the @a xlabel property to set the x-label.
function format_xaxis(par)

if exist('par', 'var')
    if isa(par, 'irdata')
        if ~isempty(par.fea_names)
            nf = numel(par.fea_x);
            MAXTICKS = 16; % Maximum 12 ticks
            nins = nf/MAXTICKS; 
            if nins > 1
                ii = round(1:nins:nf);
            else
                ii = 1:nf;
            end;
                
            set(gca, 'XTick', par.fea_x(ii));
            set(gca, 'XTickLabel', par.fea_names(ii));
        end;
    end;
    
    if isobject(par) || isstruct(par)
        ff = fields(par);
        if ismember('L_fea_x', ff) % fcon_linear
            x1 = par.L_fea_x(1);
            x2 = par.L_fea_x(end);
        elseif ismember('fea_x', ff) % irdata and others
            x1 = par.fea_x(1);
            x2 = par.fea_x(end);
        else
            irerror('parameter nas neither L_fea_x nor fea_x property!');
        end;

        if ismember('xname', ff)
            s = par.xname;
            if ismember('xunit', ff)
                if ~isempty(par.xunit);
                    s = [s ' (' par.xunit ')'];
                end;
            end;
            xlabel(s);
        end;
    else % Assumes numeric vector
        x1 = par(1);
        x2 = par(end);
    end;
else
    % Default OPUS range
    x1 = 1801.47;
    x2 = 898.81;
end;

A = .99;
if x1 == x2
    xabs = abs(x1);
    v_xlim = [x1+xabs*.9, x1+xabs*1.1];
elseif x1 > x2
    set(gca, 'XDir', 'reverse');
    v_xlim = [x2*A, x1+(x2*(1-A))];
else
    v_xlim = [x1*A, x2+(x1*(1-A))];
end;

% Xlim
set(gca, 'XLim', v_xlim);
