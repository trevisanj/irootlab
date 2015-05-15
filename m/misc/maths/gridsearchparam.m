%>@file
%>@ingroup maths misc
%
%> Grid Searc Parameter: auxiliary class for Grid Searches.
%> I think this is deprecated.
%>
%> @attention Works in log base 10
%>
%> @sa gridsearch
classdef gridsearchparam
    properties
        %> name: name of a field in '.obj'
        name = [];
        %> Double vector (numeric) / cell of strings
        %>
        %> If numeric, it is essential to be increasing.
        values = [];
        %> =0. Indicates whether the ticks and axis label should be formatted to show log values
        %>
        %> This parameter is ignored if the gridsearchparam is not numeric
        flag_log = 0;
    end;
    
    properties(Dependent)
        % Whether the possible values are numeric
        flag_numeric;
    end;
    
    methods
        function o = gridsearchparam(name_, values_, flag_log_)
            if nargin >= 1 && ~isempty(name_)
                o.name = name_;
            end;
            
            if nargin >= 2 && ~isempty(values_)
                o.values = values_;
            end;
            
            if nargin >= 3 && ~isempty(flag_log_)
                o.flag_log = flag_log_;
            end;
        end;
        
        function z = get.flag_numeric(o)
            z = isnumeric(o.values);
        end;
        
        function z = get_ticklabels(o)
            if ~o.flag_numeric
                z = o.values;
            elseif o.flag_log
                z = arrayfun(@(x) sprintf('%.3g', log10(x)), o.values, 'UniformOutput', 0);
            else
                z = arrayfun(@(x) sprintf('%.3g', x), o.values, 'UniformOutput', 0);
            end;
        end;
        
        function z = get_label(o)
            na = replace_underscores(o.name);
            f = find(o.name == '.');
            if ~isempty(f)
                na = na(f(end)+1:end); % uses only after last dot
            end;
            
            if o.flag_log && o.flag_numeric
                z = sprintf('log_{10}(%s)', na);
            else
                z = na;
            end;
        end;
        
        function z = get_value(o, idx)
            if o.flag_numeric
                z = o.values(idx);
            else
                z = o.values{idx};
            end;
        end;
        
        
        function z = get_value_string(o, idx)
            if o.flag_numeric
                z = o.values(idx);
            else
                z = o.values{idx};
            end;
            if o.flag_log
                z = ['10^', num2str(log10(z))];
            else
                z = num2str(z);
            end;
        end;
        
        %> If log, takes log
        function z = get_values_numeric(o)
            if ~o.flag_numeric
                z = 1:numel(o.values);
            elseif o.flag_log
                z = log10(o.values);
            else
                z = o.values;
            end;
        end;
        
        function z = get_legends(o)
            a = o.get_ticklabels();
            if o.flag_numeric && o.flag_log
                x = cellfun(@(z) ['10^{', z, '}'], a, 'UniformOutput', 0);
            else
                x = a;
            end;
            z = cellfun(@(x) sprintf('%s=%s', o.name, x), x, 'UniformOutput', 0);
        end;

        
        %> Keeps the span
        function o = move_to(o, idx)
            if ~o.flag_numeric
                irerror('Cannot move, grid search parameter is not numeric!');
            end;
            if o.flag_log
                v = log10(o.values);
            else
                v = o.values;
            end;
            newv = v-v(1)-(v(end)-v(1))/2+v(idx);
            if o.flag_log
                newv = 10.^newv;
            end;
            
            o.values = newv;
        end;
        
        %>
        %> [1 3 5 7] around 2 --> [1 2.3333 3.6667 5]
        %>
        function o = shrink_around(o, idx)
            if ~o.flag_numeric
                irerror('Cannot shrink, grid search parameter is not numeric!');
            end;
            ni = numel(o.values);
            if o.flag_log
                v = log10(o.values);
            else
                v = o.values;
            end;
            x2 = v(idx);
            if idx > 1 && idx < ni
                x1 = v(idx-1);
                x3 = v(idx+1);
            elseif idx == 1
                x3 = v(idx+1);
                x1 = x2-(x3-x2); % values need to be increasing
            else % idx == ni
                x1 = v(idx-1);
                x3 = x2+(x2-x1);
            end;
            
            oldspan = v(end)-v(1);
            newspan = x3-x1;
            newv = (v-v(1))*newspan/oldspan+x1;
            if o.flag_log
                newv = 10.^newv;
            end;
            
            o.values = newv;
        end;
    end;
end
                
                
