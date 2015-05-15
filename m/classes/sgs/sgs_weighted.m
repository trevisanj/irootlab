%> @brief Weighted Sub-Sampling
%>
%> Used in Adaboost
%> @sa sgs_randsub_base, uip_sgs_randsub_base.m, uip_sgs_weighted.m
classdef sgs_weighted < sgs_randsub_base
    properties
        %> weights per observation
        weights;
    end;

    methods(Access=protected)
        %> Returns a 2D cell: rows are pieces, columns are bites, elements are indexes
        function idxs = get_idxs_new(o)
            idxs = cell(o.no_pieces, 1);
            if o.flag_perclass
                for i = 1:o.no_pieces
                    no_units_sel = o.pvt_no_units_sel(i, 1); %> row vector containing number of units for each bite of the piece
                    p = weightedsubsampling(no_units_sel, o.weights(o.maps{i}));
                    idxs{i, 1} = p;
                end;
            else
                p = weightedsubsampling(o.pvt_no_units_sel(1, 1), o.weights);
                idxs{1, 1} = p;
            end;
        end;

        %> Parameter validation
        function o = do_assert(o)
            if strcmp(o.type, 'fixed')
                if numel(o.bites_fixed) > 1
                    irverbose('INFO: Only one ''bite'' will be used (the bites_fixed property has more than one element)', 2);
                end;
            else
                if numel(o.bites) > 1
                    irverbose('INFO: Only one ''bite'' will be used (the bites property has more than one element)', 2);
                end;
            end;
            if o.flag_group
                irerror('Working with groups not supported!');
            end;
            do_assert@sgs_randsub(o);
        end;
    end;

    methods
        function o = sgs_weighted(o)
            o.classtitle = 'Weighted Sub-sampling';
        end;
    end;
end