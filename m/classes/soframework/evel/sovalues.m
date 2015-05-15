
%> @brief Optimization result
%>
%> Used to typically record rates, times etc
%>
%>
%> "dimspec" specs
%> {v1, v2} | v1  (in second case, v2 will default to [1, 2, 3, ...]
%>
%> v1 is a vector where each element corresponds to one dimension within @c values. The meanings of each element are as follows:
%> @arg 0 - use that dimension
%> @arg Inf or a large number - use the last index in that dimension
%> @arg integer number within the dimension range - use the corresponding index
%>
%> v2 is a vector that, if specified, will allow for rearranging the dimensions of the squeezed new values
%>
%> Example: {[Inf, 0, 0], [1, 2]} slices through the last index of first dimension, uses dimensions 2 and 3
%>
%> Example: {[Inf, 0, 0], [2, 1]} slices through the last index of first dimension, uses dimensions 2 and 3, but in reverse order
%>
%>
classdef sovalues < irlog
    properties
        %> Structure with fields and dimensions varying
        values;

        %> Array of axisdata objects
        ax = raxisdata.empty();

        %> Chooser object
        chooser;
    end;
    

    
    methods(Static)
        %> Returns a singleton structure with fields rates, times1 etc
        function vv = read_logs(ll)
            if isempty(ll{1})
                vv = [];
                return;
            end;
            
            no_logs = numel(ll);
            % basic recording
            for m = 1:no_logs
                vv.(ll{m}.title) = ll{m}.get_rates();
            end;

            if isfield(vv, 'times1')
                % training+test time
                vv.times3 = vv.times1+vv.times2;
            end;

            % recording of the confusion matrix
            lo = ll{1};
            vv.oc = lo.extract_confusion();
        end;
        
        %> @param ll a 4D cell of logs
        %> @return A cube of structures
        function vv = read_logss(ll)
            [nj, nk, nl, lo_logs] = size(ll); %#ok<NASGU>
            
            for j = nj:-1:1
                for k = nk:-1:1
                    for l = nl:-1:1
                        vv(j, k, l) = sovalues.read_logs(ll(j, k, l, :));
                    end;
                end;
            end;
        end;
        
        
        %> @brief Merges several sovalues into one.
        %> @param oo array of sovalue
        %> @param flag_mean Whether to take means before merging
        function out = foldmerge(oo, flag_mean)
            % Identifies all numeric fields
            sov = oo(1);
            ff = fields(sov.values);
            for i = numel(ff):-1:1
                if ~isnumeric(sov.values(1).(ff{i}))
                    ff(i) = [];
                end;
            end;
            
            nv = numel(sov.values);
            nf = numel(ff);
            no = numel(oo);
            for i = 1:no
                if i == 1
                    % Initializes output ...
                    out = oo(i);
                    for k = 1:nf
                        fn = ff{k};
                        for j = 1:nv
                            out.values(j).(fn) = []; % ... with empty values
                        end;
                    end;
                end;
                    
                sov = oo(i);
                for k = 1:nf
                    fn = ff{k};
                    for j = 1:nv
                        v = sov.values(j).(fn);
                        v = v(:)'; % Makes a row vector
                        if flag_mean
                            v = mean(v);
                        end;
                            
                        out.values(j).(fn) = [out.values(j).(fn), v];
                    end;
                end;
            end;
        end;
    end;
    
    
    % High-level functionality
    methods
        %> @param name field name
        %> @param vv cell of values
        function o = set_field(o, name, vv)
            for i = 1:numel(o.values)
                o.values(i).(name) = vv{i};
            end;
        end;
            
        
        %> User chooser on values to return one sostage only
        function varargout = choose_one(o)
            if isempty(o.chooser)
                irerror('Cannot choose, chooser is empty');
            end;
            
            idxs = o.chooser.use(o.values);
            
            v = o.values(idxs{:});
            
            if nargout == 1
                varargout = {v};
            elseif nargout == 2
                varargout = {v, idxs};
            end;
        end;
        
        
        %> @param dimspec allows for insertion into specific dimensions. [n1, n2, n3, ...] where a zero means "along this dimension",
        %> @param log_cube A log_cube object
        %> and a > 0 value is an index at the corresponding dimension. It is quite tolerant with dimspec
        function o = read_log_cube(o, log_cube, dimspec)
            
            if nargin < 3
                dimspec = [];
            end;
            
                
            n_dimspec = numel(dimspec);
            nd_values = ndims(o.values);
            
            vv = o.read_logss(log_cube.logs);
            
            map = cell(1, nd_values);
            k = 0; % points to one dimension within vv
            i = 0;
            while i < n_dimspec
                i = i+1;
                if dimspec(i) == 0
                    k = k+1;
                    map{i} = 1:size(vv, k);
                else
                    map{i} = dimspec(i);
                end;
            end;
            
            % tolerance to mis-specification in dimspec
            while k < 3 % mmaximum dimensionality of vv
                k = k+1;
                i = i+1;
                map{i} = 1:size(vv, k);
            end;
            while i < nd_values
                i = i+1;
                map{i} = 1;
            end;
                
            if isempty(o.values)
                o.values = emptystruct(vv);
            end;
            
            o.values(map{:}) = vv;
        end;
        

        
        %> Report
        function s = get_html_specs(o)
            rt = cell(0, 2);
            
            if ~isempty(o.title)
                rt(end+1, :) = {'Title', o.title};
            end;
            
            if ~isempty(o.values)
                rt(end+1, :) = {'Cross-validation''s "k"', num2str(numel(o.values(1).rates))};
            end;
            
            for i = 1:numel(o.ax)
                a = o.ax(i);
                rt(end+1, :) = {a.label, cell2str(a.legends)}; %#ok<*AGROW>
            end;
                
            if ~isempty(o.values)
                ff = fields(o.values(1));
                rt(end+1, :) = {'Recordings', cell2str(ff)};
            end;
            
            
            s = '<table class=nobo>';
            
            for i = 1:size(rt, 1)
                s = cat(2, s, '<tr><td class="hel">', rt{i, 1}, '</td><td>', rt{i, 2}, '</td></tr>', 10);
            end;
            
            s = cat(2, s, '</table>', 10);
        end;

        
        %> @return The names of the fields that are numeric within values
        function ff = get_numericfieldnames(o)
            if numel(o.values) <= 0
                irerror('Values is empty, cannot get numeric field names!');
            end;
            ff = fields(o.values);
            v = o.values(1);
            for i = numel(ff):-1:1
                if ~isnumeric(v.(ff{i}))
                    ff(i) = [];
                end;
            end;
        end;
    end;
    
    

    
    
    
    

    
    
    
    %%%%%%%%%%%%%%%%%%%%% Bit lower level stuff
    %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% Static methods of public utility
    %%%%%%%%%%%%%%%%%%%%%
    
    methods(Static)
        %> Returns one of the fields of the values structure array made into a hypermatrix
        %> Mounts a matrix containing the values of a field within the "values" property specified by the "name" parameter
        %> It can work if @ref values is 2D, 3D or 4D
        function Y = getYY(vv, name)
            
            no_dims = ndims(vv);
   
            if no_dims == 2
                [ni, nj] = size(vv);
                
                for i = 1:ni
                    for j = 1:nj
                        if ~isempty(vv(i, j).(name))
                            Y(i, j, :) = vv(i, j).(name);
                        else
                            Y(i, j, :) = NaN;
                        end;
                    end;
                end;
            elseif no_dims == 3
                [ni, nj, nk] = size(vv);
                
                for i = 1:ni
                    for j = 1:nj
                        for k = 1:nk
                            if ~isempty(vv(i, j, k).(name))
                                Y(i, j, k, :) = vv(i, j, k).(name);
                            else
                                Y(i, j, k, :) = NaN;
                            end;
                        end;
                    end;
                end;
            elseif no_dims == 4
                [ni, nj, nk, nl] = size(vv);
                
                for i = 1:ni
                    for j = 1:nj
                        for k = 1:nk
                            for l = 1:nl
                                if ~isempty(vv(i, j, k, l).(name))
                                    Y(i, j, k, l, :) = vv(i, j, k, l).(name);
                                else
                                    Y(i, j, k, l, :) = NaN;
                                end;
                            end;
                        end;
                    end;
                end;
            else
                irerror(sprintf('%d-D case not supported!', no_dims-2));
            end;
        end;
        
        %> Returns values and axis data based on dimension specs
        %> @return vv, [vv, aa], or [vv, aa, aa_excluded] (See explanation)
        %>
        %> @param values Multidimensional array
        %> @param ax (Optional). Unidimensional array, where each element is semantically connected to one dimension in @c values. If not
        %> using, please pass a "[]"
        %>
        %> @arg @c vv is the values array of reduced dimension (according to dimspec)
        %> @arg @c aa contains the corresponding axisdata objects
        %> @arg @c aa_excluded containg axisdataobjects, but their ticks, labels and legends are singleton, to represent the slice across
        %> which the data was taken from the excluded dimensions (this is useful for a figure's title; see e.g. @ref vis_sovalues_drawimage.m)
        %> 
        function varargout = get_vv_aa(values, ax, dimspec)
            if ~iscell(dimspec)
                v1 = dimspec;
                v2 = [];
            else
                v1 = dimspec{1};
                v2 = dimspec{2};
            end;
            
            flag_ax = ~isempty(ax);
            
            if flag_ax
                aa2 = ax;
            end;
            
            
            % Validation
            if numel(v1) < ndims(values)
                irerror(sprintf('Dimension selector vector has only %d elements, whereas values has %d dimensions (should be at least the same)', numel(v1), ndims(values)));
            end;
            
            if ~isempty(v2)
                if sum(v1 == 0) ~= numel(v2)
                    irerror(sprintf('Dimension selector vector has %d ZERO elements, but permutation vector has %d elements (should be the same)', sum(v1 == 0), numel(v2)));
                end;
                
                v2temp = sort(v2);
                if v2temp(1) ~= 1 || any(diff(v2temp) ~= 1)
                    irerror(sprintf('Permutation vector must contain all numbers from "%d" to "%d"!', 1, sum(v1 == 0)));
                end;
            end;
            
            nd = numel(v1); % Rather than the number of dimensions of the values
            nr = sum(v1 == 0); % Number of non-singleton dimensions in the result
            
            shape = size(values);
            if numel(v1) > numel(shape)
                shape(numel(shape)+1:numel(v1)) = 1;
            end;
            shape = [shape ones(1,3-length(shape))]; % Make sure siz is at least 3-D
          
            slices = arrayfun(@(x) 1:x, shape, 'UniformOutput', 0); % Creates a cell that is initially a full map of "values"
            
            if flag_ax
                k = nr;
            end;
            for i = nd:-1:1
                if v1(i) == 0
                    if flag_ax
                        aa(k) = ax(i);
                        k = k-1;
                        
                        aa2(i) = [];
                    end;
                else
                    if v1(i) > size(values, i)
                        % Selects last
                        n = size(values, i);
                    else
                        % Selects given element
                        n = v1(i);
                    end;
                    
                    slices{i} = n;
                    shape(i) = [];
                    
                    aa2(i).values = ax(i).values(n);
                    aa2(i).ticks = ax(i).ticks(n);
                    aa2(i).legends = ax(i).legends(n);
                end;
            end;
            
            vv = values(slices{:});
%             shape2 = [shape ones(1,2-length(shape))]; % Make sure siz is at least 2-D
            vv = reshape(vv, shape);
            
            % Talvez vah ter que redefinir a maneira como algumas coisinhas sao enderecadas
            
            if ~isempty(v2)
                if flag_ax
                    aa = aa(v2);
                end;
                if numel(v2) > 1
                    vv = permute(vv, v2);
                end;
            end;
            
            if nargout == 2
                if flag_ax
                    varargout = {vv, aa};
                else
                    irerror('Number of output arguments is 2, but I didn''t get input axisdata');
                end;
            elseif nargout == 3
                if flag_ax
                    varargout = {vv, aa, aa2};
                else
                    irerror('Number of output arguments is 2, but I didn''t get input axisdata');
                end;
            else
                varargout = {vv};
            end;
        end;

    end;

    
    
    
    
    
   
    % Bit lower level stuff
    methods
        %> Mounts a matrix containing the averages of a field within the "values" property specified by the "name" parameter
        %> It can work in both the 1D and 2D cases
        function y = get_y(o, name)
            si = size(o.values);
            ni = numel(o.values);
            y = zeros(si);
            
            for i = 1:ni
                y(i) = mean(o.values(i).(name));
            end;
        end;
        
        
        %> Mounts a matrix containing the values of a field within the "values" property specified by the "name" parameter
        %> It can work if @ref values is 2D, 3D or 4D
        function Y = get_Y(o, name)
            Y = o.getYY(o.values, name);
        end;
    end;
end
