%> @brief FSG - Feature Subset Grader
%>
%> FSG is always equipped with cross-validation capability. Descendant classes must always implement the
%> cross-validation and no cross-validation cases. Whether there is cross-validation is determining by the @ref sgs
%> property being set or not.
classdef fsg < irobj
    properties
        %> =@min. Function pointer to aggregate a vector of pairwise grades. As seen, the default behaviour is taking the least grade obtained among all pairwise gradings.
        f_aggr = @(z) min(z, [], 1);
        %> SGS object. If set, 
        sgs;
        %> Some trainable block for convenience. This can be used to pass a pre_std so that it doesn't have to be part of the classifier itself.
        %> This block typically is trainable and treats the features independently. Having it as part of the classifier would result in unnecessary
        %> repetition of the same operation.
        fext;
    end;

    properties(SetAccess=protected)
        %> =0;
        flag_pairwise = 0;
        %> =0;
        flag_univariate = 0;
        grade;
        %> Assigned by @ref prepare(). This is a cell vector of Cell of matrices of @c irdata datasets
        subddd;
        %> Prepared.
        flag_sgs;
    end;
    
    properties(Access=protected)
        flag_booted = 0;
        %> The algorithm is clever enough to go non-pairwise mode if flag_pairwise is TRUE but the dataset has less than three classes
        pvt_flag_pairwise = 0;
        %> Assigned by @c set_data()
        %>
        %> If not pairwise (see @ref flag_pairwise), @c data will be assigned to @ref datasets.
        %>
        %> If pairwise, @ref datasets will be a matrix of dimensions <code>(number of pairs)x(numel(data))</code>
        %>
        %> Why one would pass a more-than-one-element dataset through @c data depends on the behaviour of a particular
        %> @ref fsg descendant. For instance a two-element vector could be a train-test pair.
        %>
        %> Please note that 
        datasets;
    end;
    
    methods
        %> @return A string for an y-axis label
        function s = get_yname(o)
            s = 'FSG';
        end;
        
        %> @return A string for a y-axis unit
        function s = get_yunit(o)
            s = '(?)';
        end;
    end;
    
    methods(Access=protected)
        %> Abstract. Must return a column vector with as elements as number of datasets
        function z = do_calculate_pairgrades(o, idxs) %#ok<INUSD>
            z = [];
        end;
        
        function o = reset(o)
            o.datasets = [];
            o.flag_booted = 0;
        end;          
    end
    
    properties(Dependent)
        %> @sa datasets
        data;
    end;
    
    methods
        %> Assigns the @ref datasets property.
        %>
        %> @sa @ref datasets
        %>
        %> @param data Vector of datasets.
        function o = set.data(o, data)
%             o.data = data;
            if isempty(data)
                o.datasets = [];
            else
                o.pvt_flag_pairwise = o.flag_pairwise && data.nc > 2;
                if ~o.pvt_flag_pairwise
                    o.datasets = data;
                else
                    % pairwise is slow, who cares
                    if numel(data) > 1
                        irwarning('One-versus-one FSG needs all datasets with exactly same classlabels');
                    end;
                    bl = blmisc_split_ovo();
                    % pairwise split is applied dataset-wise. Each dataset originates a column in o.datasets
                    o.datasets = irdata.empty;
                    for i = 1:numel(data);
                        pieces = bl.use(data(i));
                        o.datasets(:, i) = pieces';
                    end;
%                 for i = 1:length(pieces)
%                     o.datasets{i} = pieces(i);
%                 end;
                end;
            end;
        end;
        
        function o = fsg(o)
            o.classtitle = 'Feature Subset Grader';
            o.color = [170, 193, 181]/255;
        end;
        
        %> Assigns the @ref subddd property
        function o = boot(o)
            o.flag_sgs = ~isempty(o.sgs);
            if o.flag_sgs
                for i = 1:size(o.datasets, 1)
                    data = o.datasets(i, 1); % See that for cross-validaton only the first column of o.datasets is used.
                    obsidxs = o.sgs.get_obsidxs(data);
                    o.subddd{i} = data.split_map(obsidxs, [], o.fext);
                end;
            end;
            
            o.flag_booted = 1;
        end;
       
        %> May return one grade or a vector thereof
        %>
        %> @param idxs May be either: a cell of feature subsets; or a vector of feature indexes. Developers please note
        %> that it is the end class responsibility to give proper treatment to this. The option is left open for speed,
        %> as there is no point in using a cell in univariate cases.
        function grades = calculate_grades(o, idxs)
            if ~o.flag_booted
                irerror('Boot FSG first!');
            end;
            if o.flag_univariate && length(idxs{1}) > 1
                irerror('Univariate Feature-Subset Grader was requested to grade multivariate data!');
            end;

            grades_ = o.do_calculate_pairgrades(idxs);
            if o.flag_pairwise
                for k = 1:size(grades_, 3)
                    grades(:, :, k) = o.f_aggr(grades_(:, :, k));
                end;
            else
                grades = grades_;
            end;
        end;
    end;   
end
