%> @file
%> @ingroup groupgroup
%> @brief Average every ... spectra/rows
classdef rowaggr_nmean < rowaggr
    % Modes for determining the number of bins
    properties(SetAccess=private)
        % Number of bins is floor(numberOfSpectra/n)
        M_FLOOR = 1;
        % Number of bins is ceil(numberOfSpectra/n).
        % Obviously this mode will generate output dataset with more spectra
        % each corresponding to averages of less spectra if compared to M_FLOOR
        M_CEIL = 2;
    end;
    
    properties
        %> Average every ... n
        n = 10;
        %> =1. Whether to perform averaging within each group. This certainly makes sense
        %> because you don't want to average together spectra from different samples.
        flag_pergroup = 1;
        %> = rowaggr_mean.M_FLOOR. Whether to determine the number of bins by "floor" or "ceiling" modes.
        mode = 2; 
        
    end;
    
    properties(Access=protected)
        %> Temporary storage, released after @c use()' d
        indata;
        %> Temporary storage, released after @c use()' d
        outdata;
        %> Row pointer
        no_out;
    end;
    
    methods
        function o = rowaggr_nmean()
            o.classtitle = 'Average every ...';
            o.flag_trainable = 0;
            o.flag_params = 1;
        end;
        
        function z = get_no_bins(o, no_spectra)
            if o.mode == o.M_FLOOR
                z = floor(no_spectra/o.n);
            else
                z = ceil(no_spectra/o.n);
            end;
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, data)
            flag_groups = o.flag_pergroup && ~isempty(data.groupcodes);
            
            % Really didn't make much of a difference, actually it seems that comparing strings is even faster
            o.indata = data;

            % Prepares output dataset
            o.outdata = data.copy_emptyrows();
            o.no_out = 0; % Increments on this are left to process_indexes()
            o.outdata.groupcodes = cell(o.indata.no, 1); % Same number of rows to start with
            o.outdata.obsnames = cell(o.indata.no, 1);
            o.outdata.X(o.indata.no, o.indata.nf) = 0;
            o.outdata.classes(o.indata.no, 1) = 0;

            if ~flag_groups
                o = o.process_indexes(1:data.no);
            else
                % Determines the groups
                codes = unique(data.groupcodes);
                ng = numel(codes);
                
                for i = 1:ng
                    % Determines the groups
                    codes = unique(data.groupcodes);
                    idxs = find(strcmp(codes{i}, data.groupcodes)); % observation indexes
                    o = o.process_indexes(idxs);
                end;
            end;
            
            out = o.outdata;
            % Trimming
            ii = 1:o.no_out;
            out.X = out.X(ii, :);
            out.classes = out.classes(ii, :);
            out.groupcodes = out.groupcodes(ii, :);
            out.obsnames = out.obsnames(ii, :);
            o.indata = []; % Cleanup
            o.outdata = [];
        end;

        
        %> Bins the spectra indicated by idxs and averages every bin
        function o = process_indexes(o, idxs)
            no = numel(idxs);
            no_bins = o.get_no_bins(no);
            if no_bins > 0
                h = [1, hist(1:no, no_bins)];
                a = cumsum(h); % start of each bin

                for i = 1:no_bins
                    o.no_out = o.no_out+1;
                    ii = idxs(a(i):a(i+1)-1);
                    o.outdata.X(o.no_out, :) = mean(o.indata.X(ii, :), 1);
                    o.outdata.obsnames{o.no_out} = sprintf('average of %d', h(i+1));
                    o.outdata.groupcodes{o.no_out} = o.indata.groupcodes{ii(1)};
                    o.outdata.classes(o.no_out) = o.indata.classes(ii(1));
                end;
            end;
        end;
    end;

end