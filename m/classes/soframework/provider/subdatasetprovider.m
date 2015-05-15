%> @brief This class provides an incresing-in-size sequence of sub-datasets
%>
%> The smaller is always contained inside the next bigger one.
%>
%>
classdef subdatasetprovider
    properties
        %> =[1]. List of dataset percentages. The smaller dataset will be always a sub-dataset of a bigger one!
        subdspercs = 1;
        %> =0. Random seed. Using a value > 0 may be useful to reproduce the same results more than once
        randomseed = 0;
    end;
    
    methods
        %> Returns a sequence of datasets where the smaller is always contained inside the next bigger one
        %>
        %> @param ds Input dataset
        %> @param type ='primary'. 'primary', 'complement', or 'both'
        function dss = get_subdatasets(o, ds, type)
            
            if nargin < 3 || isempty(type)
                type = 'primary';
            end;
            
            flag_complement = any(strcmp(type, {'complement', 'both'}));
            flag_primary = any(strcmp(type, {'primary', 'both'}));
            
            ng = ds.no_groups;
            
            perm = o.get_perm(ng);
            
            nds = numel(o.subdspercs);
            for i = 1:nds
                if flag_primary
                    p = perm(1:floor(o.subdspercs(i)*ng));
                end;
                if flag_complement
                    p2 = perm((floor(o.subdspercs(i)*ng)+1):end);
                end;
                
                switch type
                    case 'primary'
                        maps{i} = ds.get_obsidxs_from_groupidxs(p);
                    case 'complement'
                        maps{i} = ds.get_obsidxs_from_groupidxs(p2);
                    case 'both'
                        maps(i, :) = {ds.get_obsidxs_from_groupidxs(p), ds.get_obsidxs_from_groupidxs(p2)};
                    otherwise
                        irerror(sprintf('I don''t recognize type "%s"', type));
                end;
            end;
            
            dss = ds.split_map(maps);
        end;
        
        %> Returns only the last dataset that would be returned by get_subdatasets()
        %>
        %> 'primary', 'complement', or 'both' still works here
        %>
        %> @param ds Input dataset
        %> @param type ='primary'. 'primary', 'complement', or 'both'.
        function dss = get_edgesubdataset(o, ds, type)
            
            if nargin < 3 || isempty(type)
                type = 'primary';
            end;
            
            flag_complement = any(strcmp(type, {'complement', 'both'}));
            flag_primary = any(strcmp(type, {'primary', 'both'}));
            
            ng = ds.no_groups;
            
            perm = o.get_perm(ng);
            
            if flag_primary
                p = perm(1:floor(o.subdspercs(end)*ng));
            end;
            if flag_complement
                p2 = perm((floor(o.subdspercs(end)*ng)+1):end);
            end;

            switch type
                case 'primary'
                    maps = {ds.get_obsidxs_from_groupidxs(p)};
                case 'complement'
                    maps = {ds.get_obsidxs_from_groupidxs(p2)};
                case 'both'
                    maps = {ds.get_obsidxs_from_groupidxs(p), ds.get_obsidxs_from_groupidxs(p2)};
                otherwise
                    irerror(sprintf('I don''t recognize type "%s"', type));
            end;
            
            dss = ds.split_map(maps);
        end;
    end;
    
    % Bit lower level
    methods
        %> randperm with randomseed for reproducibility, if desired
        function v = get_perm(o, ng)
            if o.randomseed > 0
                s = RandStream.getDefaultStream; % Random stream used in random functions (default one).
                save_State = s.State; % Saves state to restore later.
                reset(s, o.randomseed); % Resets state to one made from o.randomseed
            end;

            v = randperm(ng);
            
            if o.randomseed > 0
                set(s, 'State', save_State); % Restores default stream state so that random numbers can be generated as if nothing really happened here.
            end;
        end;
    end;
end
