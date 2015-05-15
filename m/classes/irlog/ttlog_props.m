%> @brief Records  properties from a block
classdef ttlog_props < ttlog
    properties
        %> Properties to record
        propnames = [];
        %> (Optional) Units corresponding to each element in propnames. Will be used by get_unit(), but this function is very tolerant
        propunits = [];
        %> (Vector of booleans, same size of ttlog_props::propnames). Whether the properties represent percentages or not. If this property is not assigned properly, 0 will be assumed whenever there
        %> is a lack of information.
        flag_perc = [];
        %> Index of property to be used by the get_rate() method
        idx_default = 1;
    end;

    properties(SetAccess=protected)
        %> Classifier's relevant properties. This is a structure array ((fields))x(time)
        propvalues = {};
    end;

    methods(Access=private)
        function z = get_flag_perc_(o, idx)
            if (~isempty(o.flag_perc) && numel(o.flag_perc) >= idx)
                z = o.flag_perc(idx);
            else
                z = 0;
            end;
        end;
    end;
    
    methods(Access=protected)
        %> Returns cell of strings for table header
        function ss = get_collabels(o)
            ss = fields(o.propvalues);
        end;
        
        %>
        function o = do_allocate(o, tt)
            vtemp = zeros(1, tt);
            o.propvalues = cell(1, numel(o.propnames));
            for i = 1:numel(o.propnames)
                o.propvalues{i} = vtemp;
            end;
        end;
    end;
    
    methods
        function o = ttlog_props()
            o.classtitle = 'Properties';
            o.flag_params = 0;
            o.moreactions = [o.moreactions, {'extract_dataset'}];
            o.flag_ui = 0;
        end;
        
% @todo Better to implement something to show detailed information in the future. In the meantime, this is NOT the solution
%        function s = get_description(o)
%            ss = '';
%            if ~isempty(o.propnames)
%                ss = [' propnames = ' cell2str(o.propnames)];
%            end;
%            s = replace_underscores([class(o) ss]);
%        end;
        
        %> @param pars Structure with a @c .clssr field.
        function o = record(o, pars)
            clssr = pars.clssr;

            o.t = o.t+1;
            % Records relevant properties from the classifier.
            for i = 1:numel(o.propnames)
                o.propvalues{i}(o.t) = clssr.(o.propnames{i});
            end;
        end;
        
        %> @brief Returns recorded information
        %>
        %> Each column corresponds to a different property.
        %>
        %> @param aggr See below
        %> <ul>
        %>   <li>Aggregation:<ul>
        %>      <li>@c 0 - INVALID</li>
        %>      <li>@c 1 - Sum</li>
        %>      <li>@c 2 - INVALID</li>
        %>      <li>@c 3 - Mean</li>
        %>      <li>@c 4 - Standard Deviation</li></ul></li>
        %>      <li>@c 5 - Minimum</li></ul></li>
        %>      <li>@c 6 - Maximum</li></ul></li>
        %> </ul>
        function X = get_X(o, aggr)
            n = numel(o.propnames);
            X = zeros(o.t, n);
            for j = 1:n
                X(:, j) = o.propvalues{j}';
            end;
            
            if exist('aggr', 'var') && aggr > 0
                switch (aggr)
                    case 1
                        X = sum(X, 1);
                    case 3
                        X = mean(X, 1);
                    case 4
                        X = std(X, [], 1);
                    case 5
                        X = min(X, [], 1);
                    case 6
                        X = max(X, [], 1);
                    otherwise
                        irerror(sprintf('Invalid option: %d', aggr));
                end;
            end;
        end;
        
        function s = get_insane_html(o, pars)
            s = stylesheet();
            ff = o.get_collabels();

            s = cat(2, s, '<h1>Classifier Properties</h1>', 10);

            % Table header
            s = cat(2, s, '<table><tr><td class="tdhe"></td>', 10);
            for i = 1:numel(ff)
                s = cat(2, s, '<td class="tdhe">', ff{i}, '</td>', 10);
            end;
            s = cat(2, s, '</tr>', 10);

            aa = {'Mean', 'Std', 'Min', 'Max'};
            bb = [3, 4, 5, 6];
            for i = 1:numel(aa)
                X = o.get_X(bb(i));
                s = cat(2, s, '<tr><td class="tdle">', aa{i}, '</td>', 10);
                for j = 1:size(X, 2)
                    s = cat(2, s, '<td class="tdnu">', num2str(X(1, j)), '</td>', 10);
                end;
                s = cat(2, s, '</tr>', 10);
            end;
            s = cat(2, s, '</table>');
        end;
        
        %> Generates one dataset with columns being propnames.
        function d = extract_dataset(o)
            d = irdata;
            d.title = ['Classifier properties'];
            d.fea_x = 1:nf;
            d.fea_names = o.propnames;
            d.X = o.get_X();
        end;
    end;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% OVERWRITTEN BEHAVIOUR
    methods
        %> Returns average recorded value for the property specified by ttlog_props::idx_default
        %> Pleas note that the name "rate" is unlikely to be the best denomination of what is actually returned (more likely to be time, or
        %> number of rules etc). Of course, the name makes more sense in the @ref estlog class
        function z = get_rate(o)
            z = mean(o.propvalues{o.idx_default});
        end;
        
        %> Returns whether the value returned by get_rate() is a percentage or not
        function z = get_flag_perc(o)
            z = o.get_flag_perc_(o.idx_default);
        end;
        
        %> Returns string
        %>
        %> Returns property name specified by ttlog_props::idx_default. The @c title property can also be used. If the ttlog's title is a
        %> string, will return the title instead
        function z = get_legend(o)
            if ischar(o.title)
                z = o.title;
            else
                z = replace_underscores(o.propnames{o.idx_default});
            end;
        end;
        
        %> Returns all recorded values of property specified by ttlog_props::idx_default
        function z = get_rates(o)
            z = o.propvalues{o.idx_default};
        end;
        
        function z = get_unit(o)
            if iscell(o.propunits) && numel(o.propunits) >= o.idx_default
                z = o.propunits{o.idx_default};
            else
                z = '?';
            end;
        end;
    end;
end
