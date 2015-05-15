%> @brief ttlogprovider for frbm classifiers
%>
%> Adds one logging "no_rules"
%>
%>
classdef ttlogprovider_frbm < ttlogprovider
    methods
        %> returns a cell array of ttlogs based on an input dataset
        %>
        %> This function returns 3 ttlogs: one to record the classification rate, another to record the training time, and another one to record the
        %> use time
        function ll = get_ttlogs(o, data)
            ll = get_ttlogs@ttlogprovider(o, data);
            
            l4 = ttlog_props();
            l4.propnames = {'no_rules'};
            l4.propunits = {'seconds'};
            l4.title = 'no_rules';
            
            ll{end+1} = l4;
        end;
    end;
end
