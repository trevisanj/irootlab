%> @brief Dataset class
%>
%> <h3>The @c X property</h3>
%> The @c X property has dimensions [@ref no]x[@ref nf]. Each row represents one physical spectrum. Each column represents a
%> "feature".
%>
%> <h3>Classes and Class Levels</h3>
%> In IRootLab, dataset @c classes are 0-based, so valid classes will range from @c 0 to @c (\ref nc-1). @c Classes correspond to elements in the
%> @c classlabels property.
%>
%> Negative classes have special meanings. See @ref get_negative_meaning.m
%>
%> The class labels may define a <bold>multi-level labelling system</bold>, with different
%> levels separated by a vertical slash ("|"). See the example:
%> @code
%> dataset1.classlabels = { ...
%> 'Normal  |UK', ...
%> 'LowGrade|UK', ...
%> 'HiGrade |UK', ...
%> 'Normal  |IR', ...
%> 'LowGrade|IR', ...
%> 'HiGrade |IR' ...
%> };
%> @endcode
%> In the example above, the first level represents the cancer grade, whereas the second level represents the country.
%> If a spectrum was taken from an individual who is from Ireland and has Low-grade cancer, its class wil be 4 (remember
%> that the classes are zero-based!). There are resources to work with class levels (see blmisc_classlabels_hierarchy)
%>
%> @sa get_negative_meaning.m, blmisc_classlabels_hierarchy
classdef irdata < irobj
    properties
        %> number of "observations" (e.g. spectra)
        no;
        %> number of features (i.e., variables)
        nf;
        %> a vector [no, nf]
        nonf;
        %> number of groups
        no_groups;
        %> number of classes
        nc;

        %> [no]x[nf] matrix. Data matrix
        X = [];
        %> [no]x[1] vector. Classes. Zero-based (first class is class zero).
        %>
        %> Classes may be negative, with special meanings for negative values (see @ref get_negative_meaning.m)
        classes = [];
        %> Cell of strings. Class labels
        classlabels = {};

        %> (optional) [no]x[1] Cell of strings. Group codes (e.g. patient names)
        groupcodes = {};
        %> (optional) [no]x[1] Cell of strings. Observation names (e.g. file names of the individual spectra)
        obsnames = {};

        filename = '';
        %> mat or txt
        filetype = '';
        
        %> feature x-axis
        fea_x = [];
        %> (optional) Cell of strings. Name of each feature
        fea_names = {};
        
        %> x-axis name, defaults to 'Wavenumber (cm^{-1})'
        xname = 'Wavenumber';
        %> x-axis unit, defaults to 'cm^{-1}'
        xunit = 'cm^{-1}';
        %> y-axis name, defaults to 'Absorbance'
        yname = 'Absorbance';
        %> y-axis unit, defaults to 'a.u.'
        yunit = 'a.u.';

        
        % Image properties
        %> Height of image. Spectra start counting from the bottom left upwards.
        height;
        %> Width of image. Width is actually calculated as @c no/height . If result is not integer, an error will occur.
        width;
        %> ='ver'. States how the pixels are organized.
        %> 'ver': bottom-up, left-right
        %> 'hor': left-right, bottom-up
        direction = 'ver';
        
        %> Output (instead of classes). For regression instead of classification
        Y = [];

        %> For easier access than groupcodes
        groupnumbers = [];
        obsids = [];
        
        splitidxs = [];
    end;
    
    properties(SetAccess=protected)
        %> fields to be split or merged when dataset is split or merged
        rowfieldnames = {'groupcodes', 'groupnumbers', 'obsnames', 'obsids', 'classes', 'X', 'Y', 'splitidxs'};
        flags_cell = [1, 0, 1, 0, 0, 0, 0, 0];
    end;
    
    methods(Access=protected)
        %> HTML inner body
        function s = do_get_html(o)
            s = '';

            s = cat(2, s, '<h1>Data classes</h1><center>', 10);
            nl = o.get_no_levels();

            
            % List of class labels with number of spectra and number of groups per class
            da = o;
            pie = data_split_classes(da);
            n = numel(pie);
            cc = cell(n+2, 4);
            cc(1, 1:4) = {'Index', 'Class label', 'Number of rows', 'Number of groups'};
            for j = 1:n
                cc(j+1, 1:4) = {j, pie(j).classlabels{1}, pie(j).no, pie(j).no_groups};
            end;
            cc(end, 1:4) = {'', 'Total', da.no, da.no_groups};
            s = cat(2, s, cell2html(cc));
            
            
            % PER-LEVEL list of class labels with number of spectra and number of groups per class
            if nl > 1
                for i = 1:nl
                    s = cat(2, s, '<h2>Level ', int2str(i), '</h2>', 10);

                    da = data_select_hierarchy(o, i);
                    pie = data_split_classes(da);
                    n = numel(pie);
                    cc = cell(n+2, 3);
                    cc(1, 1:3) = {'Class label', 'Number of rows', 'Number of groups'};
                    for j = 1:n
                        cc(j+1, 1:3) = {pie(j).classlabels{1}, pie(j).no, pie(j).no_groups};
                    end;
                    cc(end, 1:3) = {'Total', da.no, da.no_groups};
                    s = cat(2, s, cell2html(cc));
                end;
            end;
            
            
            % Negative classes (outliers etc)
            if any(o.classes < 0)
                s = cat(2, s, '<h2>Negative classes</h2>', 10);
                neg = unique(o.classes(o.classes < 0));
                nneg = numel(neg);
                
                cc = cell(nneg+1, 3);
                cc(1, 1:3) = {'Class', 'Meaning', 'Number of rows'};
                
                for i = 1:nneg
                    cc(i+1, :) = {neg(i), get_negative_meaning(neg(i)), sum(o.classes == neg(i))};
                end;
                s = cat(2, s, cell2html(cc));
            end;
            
            s = cat(2, s, '<hr />', 10);
            
            % Class means (figure)
            v = vis_means();
            figure;
            v.use(o);
            maximize_window([], 2);
            s = cat(2, s, irreport.save_n_close());
            
            
            % List of groups
            if ~isempty(o.groupcodes)
                s = cat(2, s, '<h2>Group list</h2>', 10);
                
                gg = unique(o.groupcodes);
                gg = gg(:); % To make sure that it is a column vector
                
                for i = 1:numel(gg)
                    gg{i, 2} = sum(strcmp(o.groupcodes, gg{i, 1}));
                end;
                gg = [{'Group code', 'Number of rows'}; gg]; % Adds title
                s = cat(2, s, cell2html(gg));
            end;
        
            s = cat(2, s, '</center>', 10, do_get_html@irobj(o));
        end;
    end;   
    
    
    methods
        %> Constructor
        function data = irdata()
            data.classtitle = 'Dataset';
            data.color = [5, 171, 191]/255;
        end;

        
        
        %> no getter
        function z = get.no(data)
            z = size(data.X, 1);
        end;
        
        %> nf getter
        function z = get.nf(data)
            z = size(data.X, 2);
        end
        
        %> nonf getter
        function z = get.nonf(data)
            z = size(data.X);
        end;
        
        %> nc getter
        function z = get.nc(data)
            z = length(data.classlabels);
        end;
        
        %> no_groups getter
        function z = get.no_groups(data)
            z = length(unique(data.groupcodes));
        end;
        
        function z = get.width(data)
            if data.height <= 0
                irerror('Invalid height!');
            end;
            
            z = data.no/data.height;
            if z ~= floor(z)
                irerror('Number of rows is not divisible by the dataset height!');
            end;
        end;
        
        %> Converts group codes to group indexes
        %> Indexes will point to the "unique(data.groupcodes)" vector
        function idxs = get_groupidxs_from_groupcodes(data, codes)
            n = numel(codes);
            idxs = zeros(1, n);
            ref = unique(data.groupcodes);
            for i = 1:n
                ii = find(strcmp(codes{i}, ref));
                if isempty(ii)
                    irerror(sprintf('Group code %s not present in dataset!', codes{i}));
                end;
                idxs(i) = ii;
            end;
        end;
        
        %> Converts group indexes to observation indexes
        %> CAUTION: be sure that idxs_codes contains indexes that point to
        %> the "unique(data.groupcodes)" vector
        function obsidxs = get_obsidxs_from_groupidxs(data, groupidxs)
            group_code_list = unique(data.groupcodes);
            v = 1:data.no; %> index vector

            %> Counts to pre-allocate
            cnt = 0;
            for i = 1:length(groupidxs)
                cnt = cnt+sum(strcmp(group_code_list{groupidxs(i)}, data.groupcodes));
            end;

            %> Loops again to fill
            obsidxs = zeros(1, cnt);
            ptr = 1;
            for i = 1:length(groupidxs)
                vtemp = v(strcmp(group_code_list{groupidxs(i)}, data.groupcodes));
                vlen = length(vtemp);
                obsidxs(ptr:ptr+vlen-1) = vtemp;
                ptr = ptr+vlen;
            end;
        end;
        
        %> Returns the number of levels in @c classlabels
        function nl = get_no_levels(data)
            nl = 0;
            for i = 1:data.nc
                nl = max(nl, sum(data.classlabels{i} == '|')+1);
            end;
        end;
        

        %> Checks if internal variables are synchronized with some troubleshooting.
        function data = check(data)
            if isempty(data.fea_x) || ~isempty(data.X)
                data.fea_x = 1:data.nf;
            end;
        end;
        
        
       
        %> Copies structure fields to object fields
        %> Contains a dictionary with many old property names for backward
        %> compatibility
        %> Also works when the input is an object.
        function data = import_from_struct(data, DATA)
            temp = setxor(properties(data)', {'nf', 'nonf', 'no_groups', 'nc', 'width'})';
            propmap = repmat(temp, 1, 2);
            propmap = [propmap; {'x', 'fea_x'; 'class_labels', 'classlabels'; 'idspectrum_s', 'obsids'; 'file_names', 'obsnames'; ...
                                 'colony_codes', 'groupcodes'; 'group_codes', 'groupcodes'}]; % Names that changed over time

                                 
            if ~isa(DATA, 'irdata') && ~isa(DATA, 'struct')
                irerror(['DATA argument is of class "', class(DATA), '" but should be "irdata"']);
            end;
            
            ff = fields(DATA);                   
            for i = 1:size(propmap, 1)
                sold = propmap{i, 1};
                snew = propmap{i, 2};
                if ismember(sold, ff)
                    data.(snew) = DATA.(sold);
                end;
            end;
        end;

        
        
        
        
        
        
        
        %> retains only labels corresponding to classes that exist in the
        %> dataset, and classes are renumbered accordingly
        function data = eliminate_unused_classlabels(data)
            uncl = unique(data.classes(data.classes >= 0)); % gets used classes
            data.classlabels = data.classlabels(uncl+1);

            for j = 1:numel(uncl)
                data.classes(data.classes == uncl(j)) = j-1;
            end;
        end;

        %> @brief Populates from a time series
        %> 
        %> This function makes X and Y. X will be a Toeplitz matrix.
        %> 
        %>
        %> Inputs:
        %> @param signal vector s(n)
        %> @param no_inputs dimensionality of the input data space (aka number of features or nf)
        %> @param future "prediction task", which will be to predict s(n+future)
        function data = mount_from_signal(signal, no_inputs, future)

            len_signal = length(signal);


            %>This is the maximum number of rows of the dataset before something blows
            no_rows = len_signal-no_inputs-future;


            %>Mounts X and Y
            X = zeros(no_rows, no_inputs);
            Y = zeros(no_rows, 1);

            for i = 1:no_rows
                %> each data row will stand for [s(n) s(n-1) s(n-2) ...]. This way the dot product between the row and the 
                %> coefficients of a linear filter is a causal convolution.
                X(i, :) = signal(i+no_inputs-1:-1:i);
                Y(i, 1) = signal(i+no_inputs-1+future);
            end;

            data.X = X;
            data.Y = Y;
        end;
        
        

        %> Gets a list with all properties except the ones that will be
        %> split
        function pp = get_props_to_copy(data)
            pp = setxor(properties(data), data.rowfieldnames);
            pp = setxor(pp, {'flag_params', 'rowfieldnames', 'flags_cell'});
        end;
        
        %> Makes copy with empty fields whose names are in .rowfieldnames
        %> Additionally, resets .height
        function dnew = copy_emptyrows(data)
            dnew = data;
            dnew.height = [];
            rr = data.rowfieldnames;

            for i = 1:numel(rr)
                if data.flags_cell(i)
                    dnew.(rr{i}) = {};
                else
                    dnew.(rr{i}) = [];
                end;
            end;
%             tt = tic();
%             global TIMEFSG;
%             pp = data.get_props_to_copy();
%             TIMEFSG = TIMEFSG+toc(tt);
%             dnew = feval(class(data));
%             for j = 1:length(pp)
%                 dnew.(pp{j}) = data.(pp{j});
%             end
        end;
            
        
        
        
        
        
        
        
        
        %> Splits dataset into one or more datasets using row maps
        %>
        %> @param map 1D or 2D cell array of row indexes
        %> @param feamap (optional
        %> @retval out Matrix of datasets.
        function out = split_map(data, map, feamap, fext)
            
            if ~iscell(map)
                map = {map};
            end;
            
            flag_fext = nargin > 3 && ~isempty(fext);
            if flag_fext 
                if ~fext.flag_trainable
                    irerror('fext parameter must be trainable, otherwise it does not make sense!');
                end;
                fext = fext.boot();
            end;
            
            flag_feamap = nargin >= 3 && ~isempty(feamap);
            
            rr = data.rowfieldnames;
            nr = numel(rr);
            flags = arrayfun(@(k) ~isempty(data.(rr{k})), 1:nr);

            [nrow, ncol] = size(map);
            
            dnew0 = data.copy_emptyrows(); % Model copy

            if nrow == 0 || ncol == 0
                out = [];
            else
                %s = '-<';
                for i = nrow:-1:1 % Goes backwards to pre-allocate although MATLAB doesn't know.
                    for j = 1:ncol
                        %> prepares a clone, except for the fields in rowfieldnames
                        dnew = dnew0;

                        %> maps the rowfieldnames fields
                        idxs = map{i, j};                  
                        for k = 1:nr
                            if flags(k) %> maps only the fields that are not empty. This allows fields to
                                        %> be used or not as necessary and no error will occur.
                                dnew.(rr{k}) = data.(rr{k})(idxs, :);
                            end;
                        end;

                        dnew = dnew.eliminate_unused_classlabels();
                        
                        if flag_fext 
                            if j == 1
                                fextnow = fext.boot();
                                fextnow = fextnow.train(dnew);
                            end;
                            dnew = fextnow.use(dnew);
                        end;
                            
                            
                            
                        
                        if flag_feamap
                            out(i, j, :) = dnew.select_features(feamap);
                        else
                            out(i, j) = dnew;
                        end;
                        %s = cat(2, s, sprintf('+split%d,%d+', i, j));
                    end;
                end;
                %s = cat(2, s, sprintf('>-\n'));
                %irverbose(s, 0);
            end;
        end;
        

        
        
        %> Splits dataset into one or more datasets using its own splitidxs property
        %>
        %> @param map 1D or 2D cell array of row indexes
        %> @retval out Matrix of datasets.
        function out = split_splitidxs(data)
            out = data.split_map(splitidxs2maps(data.splitidxs));
        end;
        
        
        %> Maps rows. Single-output version of split_map()
        %>
        %> Returns new object
        function out = map_rows(data, idxnew)
            out = data.split_map({idxnew});
        end;
        
        
        %> Manual feature selection.
        %>
        %> Inputs:
        %>   idxs: list of column indexes to select, or cell thereof
        function out = select_features(data, idxs)
%             nfold = data.nf;
            if ~iscell(idxs)
                out = data;
                out.X = data.X(:, idxs);
                if ~isempty(data.fea_x)
                    out.fea_x = out.fea_x(idxs);
                end;
                if ~isempty(out.fea_names)
                    out.fea_names = out.fea_names(idxs);
                end;
            else
                nell = numel(idxs);
                for i = 1:nell
                    if i == 1
                        out(nell) = data; % Pre-allocation
                        out(1) = data;
                    elseif i < nell
                        out(i) = data;
                    end;
                    out(i).X = data.X(:, idxs{i});
                    if ~isempty(data.fea_x)
                        out(i).fea_x = out(i).fea_x(idxs{i});
                    end;
                    if ~isempty(data.fea_names)
                        out(i).fea_names = out(i).fea_names(idxs{i});
                    end;
                end;
            end;
%>             irverbose(sprintf('INFO (data_select_features()): # features before: %>d; # features after: %>d.\n', nfold, data.nf));
        end;
       
        
        %> @brief Transforms dataset using loadings matrix L
        %>
        %> data.X = data.X*L;
        %> data.xlabel = 'Factor';
        %> data.ylabel = 'Score';
        %>
        %> @param L[nf][any] Loadings matrix
        %> @param L_fea_prefix=[] Prefix to make new feature names.
        function data = transform_linear(data, L, L_fea_prefix)
            data.X = data.X*L;
            data.fea_x = 1:data.nf;
            data.xname = 'Factor';
            data.xunit = [];
            data.yname = 'Score';
            data.yunit = [];

            % Makes feature names
            if exist('L_fea_prefix', 'var') && ~isempty(L_fea_prefix)
                data.fea_names = cell(1, data.nf);
                for i = 1:data.nf
                    data.fea_names{i} = [L_fea_prefix int2str(i)];
                end;
            else
                data.fea_names = {};
            end;
        end;        
        
        
        %> @brief Returns the names of the features.
        %>
        %> This function checks the \c fea_names property and if it is empty, it makes feature names on-the-fly using
        %> the \c fea_x property.
        %>
        %> @param idxs Optional list of indexes to be returned
        function names = get_fea_names(data, idxs)
            if ~exist('idxs', 'var')
                idxs = 1:data.nf;
            end;
            
            if ~isempty(data.fea_names)
                names = data.fea_names(idxs);
            else
                names = cell(1, length(idxs));
                for i = 1:length(idxs)
                    names{i} = sprintf('Feature %g', round(data.fea_x(idxs(i))*10)/10);
                end;
            end;
        end;
        
        %> @brief fills in the @ref groupnumbers property based on the @ref groupcodes property.
        function data = make_groupnumbers(data)
            if isempty(data.groupcodes)
                irverbose('INFO: Dataset groupcodes is empty!', 1);
                return;
            end;
            
            % Determines the groups
            codes = unique(data.groupcodes);
            ng = numel(codes);
            data.groupnumbers = zeros(data.no, 1);
            
            for i = 1:ng  
                data.groupnumbers(strcmp(codes{i}, data.groupcodes)) = i;
            end;
        end;
        
        
        %> @brief Makes the dataset properties consistent with each other
        %>
        %> This is both an assertion routine and a "fixing" routine. The two parts are implemented sequentially, so it will be easy to split
        %> this in the future.
        %> 
        %> The assertion part will do a number of checks and throw an error if there is no hope of making it a consistent dataset. Fatal
        %> problems will be:
        %> @arg not empty row fields (listed in the @ref irdata::rowfieldnames read-only property) of different sizes
        %> @arg @ref irdata::fea_x with number of elements different from @ref irdata::nf
        %>
        %> The subsewquent fix part may do a number of works on the dataset:
        %> @arg autofill the "classes" vector if it is empty (and create a default class label)
        %> @arg autogenerate the "fea_x" vector if it is empty
        %> @arg add elements to @ref irdata::classlabels if class numbers surpass the number of labels
        %>
        function data = assert_fix(data)
            %%%%%% Assertion
            
            %%% Consistent number of rows
            nref = -1;
            for i = 1:numel(data.rowfieldnames)
                ni = size(data.(data.rowfieldnames{i}), 1);
                if nref == -1
                    if ni > 0
                        nref = ni;
                        iref = i;
                    end;
                else
                    if ni > 0
                        if ni ~= nref
                            irerror(sprintf('Fields "%s" and "%s" have different numbers of rows!', data.rowfieldnames{iref}, data.rowfieldnames{i}));
                        end;
                    end;
                end;
            end;
            
            %%% Consistent fea_x and nf
            if ~isempty(data.fea_x) && size(data.fea_x, 2) ~= data.nf
                irerror(sprintf('dataset has %d features, but x-axis vector has %d elements!', data.nf, size(data.fea_x, 2)));
            end;
            
            
            
            %%%%%% Fixing
            
            %%% Classes
            if data.no > 0 && isempty(data.classes)
                data.classes = zeros(data.no, 1);
                data.classlabels = {'Class 0'};
            end;
            
            %%% fea_x
            if data.nf > 0 && isempty(data.fea_x)
                data.fea_x = 1:data.nf;
            end;
            
            %%% Class labels
            if ~isempty(data.classlabels) && ~iscell(data.classlabels)
                irerror('"classlabels" must be a cell!');
            end;
            nceff = max(data.classes)+1;
            ncthought = numel(data.classlabels);
            if nceff > ncthought
                nl = data.get_no_levels();
                ss = char('|'*ones(1, nl-1));
                for i = nceff:-1:ncthought+1
                    data.classlabels{i} = sprintf('Class %d%s', i-1, ss);
                end;
            end;
        end;
        
        %> Gets weights for each class
        %>
        %> Weights are inversely proportional to the number of observations in each class.
        %>
        %> Weights are normalized, so that their sum equals one
        %> @param exponent =1. Exponent to power all weights before they are normalized to sum=1
        function ww = get_weights(data, exponent)
            ww = zeros(1, data.nc);
            for i = 1:data.nc
                ww(i) = 1/sum(data.classes == (i-1));
            end;

            if nargin > 1 && ~isempty(exponent)
                ww = ww.^exponent;
            end;
            ww = ww/sum(ww);
        end;

        
        
        %> Changes direction and swaps width and height
        %>
        %> This is called "transpose2" because MATLAB objects have a built-in 
        %> "transpose" already
        function data = transpose2(data)
            hei = data.height;
            if isempty(hei)
                irerror('Height not provided and dataset does not have height.');
            end;
            wid = data.no/hei;
            if floor(wid) ~= wid
                irerror(sprintf('Height %d not divisible by %d!', hei, data.no));
            end;

            if strcmp(data.direction, 'hor')
                data.direction = 'ver';
            else
                data.direction = 'hor';
            end;
            data.height = wid;
        end;
        
        %> Asserts that there is no NaN in data.X
        function data = assert_not_nan(data)
            if any(isnan(data.X))
                irerror('Dataset X property has NaNs!!!');
            end;
            if any(isnan(data.classes))
                irerror('Dataset classes property has NaNs!!!');
            end;
        end;
    end;
end
