%> @file
%> @ingroup groupgroup

%> @brief Group Aggregator - combines data rows outputting one row per group
classdef grag < rowaggr
    properties(Access=protected)
        %> Temporary storage, released after @c use()' d
        indata;
        %> Temporary storage, released after @c use()' d
        outdata;
        %> Row pointer
        no_out;
    end;

    methods
        function o = grag(o)
            o.classtitle = 'Group aggregator';
            o.flag_trainable = 0;
            o.flag_params = 0;
        end;
    end;
    
    methods(Access=protected)
        %> Abstract. Core. Task is to assign data properties of row @c no_out .
        function o = process_group(o, idxs)
        end;
        
        %> Needs to pre-allocate the relevant row fields of @c outdata .
        function o = dim_outdata(o, ng)
        end;
        
        function out = do_use(o, data)
            if isempty(data.groupcodes)
                irerror('Dataset groupcodes is empty!');
            end;
            
            % Really didn't make much of a difference, actually it seems that comparing strings is even faster
            if 1
                o.indata = data;

                % Determines the groups
                codes = unique(data.groupcodes);
                ng = numel(codes);

                % Prepares output dataset
                o.outdata = data.copy_emptyrows();
                o.no_out = 0;
                o.outdata.groupcodes = cell(ng, 1);
                o = o.dim_outdata(ng);


                for i = 1:ng  
                    o.no_out = o.no_out+1;
                    
                    % Half the bottleneck is here
                    idxs = find(strcmp(codes{i}, data.groupcodes)); % observation indexes
                    o.outdata.groupcodes{o.no_out} = o.indata.groupcodes{idxs(1)};
                    
                    % The other half is here
                    o = o.process_group(idxs);
                end;

            else
                o.indata = data;

                % Determines the groups
                numbers = unique(data.groupnumbers);
                ng = numel(numbers);

                % Prepares output dataset
                o.outdata = data.copy_emptyrows();
                o.no_out = 0;
                o.outdata.groupcodes = cell(ng, 1);
                o = o.dim_outdata(ng);


                for i = 1:ng  
                    o.no_out = o.no_out+1;
                    idxs = find(numbers(i) == data.groupnumbers);
                    o.outdata.groupcodes{o.no_out} = o.indata.groupcodes{idxs(1)};
                    o.outdata.groupnumbers(o.no_out) = o.indata.groupnumbers(idxs(1));
                    o = o.process_group(idxs);
                end;
            end;
            
            
            out = o.outdata;
            o.indata = [];
            o.outdata = [];
        end;
    end;
end