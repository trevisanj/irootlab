%> @brief Base Sub-dataset Generation Specification (SGS) class
%>
%> This class generates index maps to sub-datasets, formulating these maps according to various
%> criteria, including cross-validation, random sub-sampling, and weighted sub-sampling.
%>
classdef sgs < irobj
    properties
        %> =0. Whether items from the same group (group) are to always remain together.
        flag_group = 0;
        %> =0. Whether to perform on each class separately.
        flag_perclass = 0;
        %> =0. Random seed. Only used if > 0.
        %> if > 0, MATLAB's rand('twister', o.randseed) will be called before. This can be used to repeat sequences.
        randomseed = 0;
        
        %> read-only
        no_pieces;
    end;
    
    
    
    properties(Access=protected)
        flag_setup = 0;
        data;
        pieces;
        %> Number of "units" in dataset. This may be a single value containing
        %> the number of observations or groups, depending on .flag_group, or
        %> a vector containing that information for each class, if .flag_perclass is
        %> True.
        no_unitss;
        maps;
        
        %> Calculated upon setup, will be zero if flag_group but dataset has no groups
        pr_flag_group;
    end;


    methods(Access=private)
        %> Builds a 2D cell where rows are repetitions and columns are bites
        %> repidxs is 1 1D cell of 2D cells. Within each 2D cells, rows are pieces and columns are bites, and elements
        %> are indexes
        function obsidxs = convert_to_obs(o, repidxs)
            no_reps = length(repidxs);
            no_bites = size(repidxs{1}, 2);
            obsidxs = cell(no_reps, no_bites);
            flag_verbose = o.no_reps > 20;
            
            if flag_verbose
                ipro = progress2_open('SGS-convert_to_obs', [], 0, no_reps);
            end;
            for i = 1:no_reps
                flag_mergeobs = 0; %> Switch for the second task inside the loop
                
                if o.pr_flag_group
                    if o.flag_perclass
                        %> In the grouped, per-class case, converts to per-piece observation to later use the common
                        %> fragment below
                        for j = 1:no_bites
                            for k = 1:o.no_pieces
                                repidxs{i}{k, j} = o.pieces(k).get_obsidxs_from_groupidxs(repidxs{i}{k, j});
                            end;
                        end;
                        flag_mergeobs = 1;
                    else
                        for j = 1:no_bites
                            obsidxs{i, j} = o.data.get_obsidxs_from_groupidxs(repidxs{i}{1, j});
                        end;
                    end;

                else
                    if o.flag_perclass
                        flag_mergeobs = 1;
                    else
                        obsidxs(i, :) = repidxs{i}(1, :);
                    end;
                end;
                
                if flag_mergeobs                
                    idxs_onerep = repidxs{i};
                    nos = arrayfun(@(a) length(a{1}), idxs_onerep);
                    no_perbite = sum(nos, 1);

                    for j = 1:no_bites
                        obsidxs{i, j} = zeros(1, no_perbite(j));

                        ptr = 1;
                        for k = 1:o.no_pieces
%>                             keyboard;
                            obsidxs{i, j}(ptr:ptr+nos(k, j)-1) = o.maps{k}(idxs_onerep{k, j});
                            ptr = ptr+nos(k, j);
                        end;
                    end;
                end;
              
                if flag_verbose
                    ipro = progress2_change(ipro, [], [], i);
                end;
                
            end;
        
            if flag_verbose
                progress2_close(ipro);
            end;
        end;
    end;

    methods(Access=protected)
        %> Must be implemented at the descendants, this is essentially what is different for every different sgs method
        %> This function is group-or-observation-unaware
        %> Returns a 1D cell array or 2D cell arrays. Each element/2D cell array contains one row per piece and one
        %> column per bite. 
        %> This function does not know if it is working with groups or observations
        function idxs = get_repidxs(o)
        end;
        
        %> Must be implemented at the descendants
        function o = do_setup(o)
        end;
        
        %> Data-independent validation
        function o = do_assert(o)
        end;
    end;
    
    methods
        function o = sgs(o)
            o.classtitle = 'Sub-dataset Generation Specs';
            o.color = [164, 100, 100]/255;
        end;
        
        %> If hasn't been setup yet, will return a NaN
        function z = get.no_pieces(o)
            if ~o.flag_perclass
                z = 1;
            elseif isempty(o.pieces)
                z = NaN; % irerror('Did not have contact with dataset yet!');
            else
                z = length(o.pieces);
            end;
        end;

        function o = setup(o, data)
            o = o.assert();
            o.data = data;
            
            
            o.pr_flag_group = o.flag_group && ~isempty(data.groupcodes) && data.no_groups < data.no;
            if o.flag_group && isempty(data.groupcodes)
                irverbose('INFO: will not group rows because data groupcodes is empty!');
            end;
            if o.flag_group && data.no_groups == data.no
                irverbose('INFO: will not group rows because number of groups equals number of spectra.');
            end;
            
            %> Solves o.no_unitss
            if o.flag_perclass
                [o.pieces, o.maps] = data_split_classes(o.data);
                if o.pr_flag_group
                    for i = 1:o.no_pieces
                        o.no_unitss(i) = o.pieces(i).no_groups;
                        if o.no_unitss(i) == 0; irerror('Number of groups in dataset piece is zero!'); end;
                    end;
                else
                    for i = 1:o.no_pieces
                        o.no_unitss(i) = o.pieces(i).no;
                        if o.no_unitss(i) == 0; irerror('Dataset piece has no rows!'); end;
                    end;
                end;
            else
                if o.pr_flag_group
                    o.no_unitss = o.data.no_groups;
                    if o.no_unitss == 0; irerror('Number of groups in dataset is zero!'); end;
                    
                else
                    o.no_unitss = o.data.no;
                    if o.no_unitss == 0; irerror('Dataset has no rows!'); end;
                end;
            end;
                        
            o = o.do_setup(); %> class-specific setup
            o.flag_setup = 1;
        end;
        
        
       
            
        function obsidxs = get_obsidxs(o, data)
            if o.randomseed > 0
                try
                    s = RandStream.getDefaultStream; % Random stream used in random functions (default one).
                catch
                    % 20150414 -- Above has been renamed; preserving
                    % backwards compatibility
                    % Reference:
                    % http://stackoverflow.com/questions/24640216/how-to-achieve-randstream-getdefaultstream-in-matlab2014a
                    s = RandStream.getGlobalStream;
                end;
                save_State = s.State; % Saves state to restore later.
                reset(s, o.randomseed); % Resets state to one made from o.randomseed
            end;

%             if ~o.flag_setup
            % Of course I have to always call setup!
                o = o.setup(data);
%             end;
            idxs = o.get_repidxs();
            obsidxs = o.convert_to_obs(idxs);
            
            if o.randomseed > 0
                set(s, 'State', save_State); % Restores default stream state so that random numbers can be generated as if nothing really happened here.
            end;
        end;
        
        %> Data-independent validation. Can be used at the GUI to check for parameter inconsistencies.
        function o = assert(o)
            o = do_assert(o);
        end;
    end;
end