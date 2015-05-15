%> @brief Provides cell of ttlog objects
%>
%> This was made into a class so that in eClass cases 
%>
%>
classdef ttlogprovider
    methods
        %> returns a cell array of ttlogs based on an input dataset
        %>
        %> This function returns 3 ttlogs: one to record the classification rate, another to record the training time, and another one to record the
        %> use time
        function ll = get_ttlogs(o, data)
            ll = {};

            log = estlog_classxclass();
%             log.title = 'Classification Rate';
            log.estlabels = data.classlabels;
            log.testlabels = data.classlabels;
            log.title = 'rates';
            l1 = log;
            ll{end+1} = log;

            log = ttlog_props();
%             log.title = 'Training time';
            log.propnames = {'time_train'};
            log.propunits = {'seconds'};
            log.title = 'times1';
            ll{end+1} = log;
            
            log = ttlog_props();
%             log.title = 'Test time';
            log.propnames = {'time_use'};
            log.propunits = {'seconds'};
            log.title = 'times2';
            ll{end+1} = log;
        end;
    end;
end
