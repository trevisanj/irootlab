%>@file
%>@ingroup misc classlabelsgroup

%> @brief Used by parse_classmaps.m
%>
%> Facilitates generation of lists of sub-datasets -- specified by the classes that go into each -- using expression
%> strings.
%>
%> This class implements operations: plus, not, and unary minus
%>
%> @sa parse_classmaps.m
classdef classsplitter
    properties(Dependent)
        classlabels;
        %> Hierarchical level(s) that will be used to isolate only certain classes within the dataset to work on. When you call @ref
        %> set_baselabel(), you will define which class labels mounted using the levels in @c hie_base only will be considered for the
        %> arithmetical operations
        hie_base;
        %> Split level(s).
        hie_split;
    end;
    
    properties(Access=protected)
        classlabels_;
        hie_split_;
        hie_base_;
        %> Obtained using @c classlabels2cell() once @c classlabels and @c hie are set
        cellmap_data;
        %> Obtained using @c classlabels2cell() once @c classlabels and @c hie are set
        cellmap_split;
        %> Assigned by setting @c datalabel
        activeidxs_;
    end;
    
    properties(SetAccess=protected)
        map;
    end;
    
    methods
        function o = set.classlabels(o, x)
            o.classlabels_ = x;
            o = o.calculate_cellmaps();
        end;
        
        function z = get.classlabels(o)
            z = o.classlabels_;
        end;
        
        function o = set.hie_split(o, x)
            o.hie_split_ = x;
            o = o.calculate_cellmaps();
        end;

        function z = get.hie_split(o)
            z = o.hie_split_;
        end;

        function o = set.hie_base(o, x)
            o.hie_base_ = x;
            o = o.calculate_cellmaps();
        end;
        
        function z = get.hie_base(o)
            z = o.hie_base_;
        end;
        
        function o = calculate_cellmaps(o)
            if ~isempty(o.classlabels)
                if ~isempty(o.hie_split)
                    o.cellmap_split = classlabels2cell(o.classlabels_, o.hie_split_);
                end;
                if ~isempty(o.hie_base)
                    o.cellmap_data = classlabels2cell(o.classlabels_, o.hie_base_);
                end;
            end;
        end;
              
        function o = set_baselabel(o, labels)
            if ischar(labels)
                labels = {labels};
            end;
            
            boolidxs = zeros(1, length(o.classlabels_));
            for i = 1:length(labels)
                boolidxs = boolidxs | strcmp(labels{i}, o.cellmap_data(:, 3))';
            end;
            o.activeidxs_ = find(boolidxs);
            o.map = {o.activeidxs_}; % Map is set initially to active indexes
        end;
        
        function z = get.map(o)
            z = o.map;
        end;
        
        
        function o = uminus(o)
            splitclasses = cell2mat(o.cellmap_split(:, 4));
            n = numel(unique(splitclasses));
            o.map = cell(1, n);
            for i = 1:n
                o.map{i} = setxor(intersect(find(splitclasses == i-1), o.activeidxs_), o.activeidxs_);
            end;
        end;
        
        function o = plus(o, o2)
            o.activeidxs_ = union(o.activeidxs_, o2.activeidxs_);
            temp = o.map;
            o.map = cell(1, numel(o.map)*numel(o2.map));
            k = 0;
            for i = 1:numel(temp)
                for j = 1:numel(o2.map)
                    k = k+1;
                    o.map{k} = [temp{i}, o2.map{j}];
                end;
            end;
        end;
        
        function o = not(o)
            for i = 1:numel(o.map)
                o.map{i} = setxor(o.map{i}, o.activeidxs_);
            end;
        end;
    end;
end
