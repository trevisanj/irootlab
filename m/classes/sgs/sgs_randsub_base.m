%> @brief Random Sub-sampling base class
%>
%> http://en.wikipedia.org/wiki/Cross-validation_%28statistics%29#Repeated_random_sub-sampling_validation
%>
%> @sa uip_sgs_randsub_base.m
classdef sgs_randsub_base < sgs
    properties(Access=protected)
        pvt_flag_fixed;  %> when flag_balanced is true, will be true and pvt_bitess_fixed will be calculated
        pvt_no_units_sel; %> matrix: one row per piece, one column per bite
    end;
    
    properties
        %> =[.9, .1]: vectors of percentages.
        bites = [.9, .1];
        %> ='simple'. String containing one of the following possibilities:
        %> @arg @c 'simple' uses percentages in bites
        %> @arg @c 'balanced' same number of units are picked within each class. Needs flag_perclass to be TRUE, otherwise will give error. The "bites" property will be used to calculate fixed number of units
        %> @arg @c 'fixed' fixed number of units are picked. Uses bites_fixed
        type = 'simple';
        %> Used only if @c type is @c 'fixed', otherwise bites will be used.
        bites_fixed;
        %> =10. The number of repetitions.
        no_reps = 10;
    end;

    methods(Access=protected)
        %> Returns a 2D cell: rows are pieces, columns are bites, elements are indexes
        function idxs = get_idxs_new(o)
            
            idxs = cell(o.no_pieces, size(o.pvt_no_units_sel, 2));
            for i = 1:o.no_pieces;
                no_units_sel = o.pvt_no_units_sel(i, :); %> row vector containing number of units for each bite of the piece
                p = randperm(o.no_unitss(i));
                ptr = 1;
                for j = 1:length(no_units_sel)
                    idxs{i, j} = p(ptr:ptr+no_units_sel(j)-1);
                    ptr = ptr+no_units_sel(j);
                end;
            end;
        end;

        %> Overwrittern
        function idxs = get_repidxs(o)
            idxs = cell(1, o.no_reps);
            for i = 1:o.no_reps
                idxs{i} = o.get_idxs_new();
            end;
        end;
        
        %> Parameter validation
        function o = do_assert(o)
            if strcmp(o.type, 'balanced') && ~o.flag_perclass
                irerror('For balanced Random Subsampler, flag_perclass must be TRUE!')
            end;
            
            if (strcmp(o.type, 'simple') || strcmp(o.type, 'balanced')) && sum(o.bites) > 1
                irerror('Sum of all elements in the "bites" vector needs be <= 1!');
            end;
        end;
        
        function o = do_setup(o)
            o.pvt_flag_fixed = strcmp(o.type, 'fixed') || strcmp(o.type, 'balanced');
            if strcmp(o.type, 'balanced')
                minunits = min(o.no_unitss);
                o.pvt_no_units_sel = repmat(percs2no_unitss(o.bites, minunits), o.no_pieces, 1);
            elseif strcmp(o.type, 'fixed')
                minunits = min(o.no_unitss);
                if sum(o.bites_fixed) > minunits
                    irerror(sprintf('Sum of number of fixed units is too big for dataset (should be <= %d)!', minunits));
                end;
                o.pvt_no_units_sel = repmat(o.bites_fixed, o.no_pieces, 1);
            else
                o.pvt_no_units_sel = zeros(o.no_pieces, length(o.bites));
                for i = 1:o.no_pieces
                    o.pvt_no_units_sel(i, :) = percs2no_unitss(o.bites, o.no_unitss(i));
                end;
            end;
        end;
    end;

    methods
        function o = sgs_randsub_base(o)
            o.classtitle = 'Random Sub-sampling base class';
        end;

        function idxs = get_obsidxs_new(o)
            if ~o.flag_setup
                irerror('Must call setup() first!');
            end;
            
            tmp_save = o.no_reps;
            o.no_reps = 1;
            idxs = o.get_obsidxs();
            o.no_reps = tmp_save;
        end;
    end;
end