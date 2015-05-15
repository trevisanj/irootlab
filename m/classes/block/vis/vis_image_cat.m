%> @brief Image map for non-ordered, discrete features (e.g. from clustering)
%>
%> @sa uip_vis_image_cat.m
classdef vis_image_cat < vis
    properties
        %> =0. 0: feature; 1: class
        mode = 0;
        %> =1. Index of feature in case @c mode is 0.
        idx_fea = 1;
        %> Whether to stretch the image to occupy the whole figure area
        flag_set_position = 1;
        % Minimum number of points per category
        min_ppc;
        % Maximum num,ber of categories
        max_c;
    end;
    
    methods
        function o = vis_image_cat(o)
            o.classtitle = 'Image map - Cluster data';
            o.inputclass = 'irdata_clus';
        end;
    end;
    
    methods(Access=protected)
        
        function Z = get_Z(o, data)
            if o.mode == 0
                Z = data.X(:, o.idx_fea)';
            elseif o.mode == 1
                error('Not implemented for "class" mode yet, sorry');
            else
                irerror(sprintf('Invalid mode: %d', o.mode));
            end;
        end;
        
       
        function data = implement_min_ppc(o, data)
            Z = o.get_Z(data);
            
            nums = unique(Z);

            counts = diff(find([1, diff(sort(Z)), 1])); % Finds how many times each number appears
            
            idxs = find(counts < o.min_ppc);
            
%             feanew = numel(counts)-numel(idxs)+1;
            feanew = 2*(numel(counts)-numel(idxs));
            
            if ~isempty(idxs)
%                 ZZ = Z+1;
                ZZ = Z;
                
                for i = 1:numel(idxs)
                    ZZ(Z == nums(idxs(i))) = feanew; %1;
                end;
                if o.mode == 0
                   data.X(:, o.idx_fea) = ZZ';
                elseif o.mode == 1
                    % ...
                end;
             end;
            
        end;        
        
        
        function out = do_use(o, obj)
            out = [];
            if isempty(obj.height) || obj.height < 1
                irerror('Dataset has no defined image dimensions!');
            end;
            
            % Makes a dataset sorted by number of occurences in the last column
            if o.mode == 0
                Z = obj.X(:, o.idx_fea);
                classlabels = [];
            elseif o.mode == 1
                Z = obj.classes;
                classlabels = obj.classlabels;
            else
                irerror(sprintf('Invalid mode: %d', o.mode));
            end;

            Z = renumber_vector_idooo(Z);
            
            draw_indexedimage(Z, obj.height, obj.direction, classlabels);
            set_title(o.classtitle, obj);
            
            if o.flag_set_position
                set(gca, 'Position', [0, 0, 1, 1]);
            end;

        end;
    end;
end
