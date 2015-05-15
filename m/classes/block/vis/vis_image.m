%> @brief Image map
%>
%> @sa uip_vis_image.m
classdef vis_image < vis
    properties
        %> =0. 0: feature; 1: class; 2: y
        mode = 0;
        %> =1. Index of feature in case @c mode is 0.
        idx_fea = 1;
        %> Whether to stretch the image to occupy the whole figure area
        flag_set_position = 1;
    end;
    
    methods
        function o = vis_image(o)
            o.classtitle = 'Image map';
            o.inputclass = 'irdata';
        end;
    end;
    
    methods(Access=protected)
        function out = do_use(o, obj)
            out = [];
            if isempty(obj.height) || obj.height < 1
                irerror('Dataset has no defined image dimensions!');
            end;
            
            % Makes a dataset sorted by number of occurences in the last column
            if o.mode == 1 % classes
                Z = obj.classes;
                Z = renumber_vector_idooo(Z);
                draw_indexedimage(Z, obj.height, obj.direction, obj.classlabels);
            elseif o.mode == 0 || o.mode == 2 % feature or Y
                if o.mode == 0
                    x = obj.X(:, o.idx_fea);
                elseif o.mode == 2
                    x = obj.Y(:, 1);
                end;
                
                x(obj.classes < 0) = NaN;

                draw_image(x, obj.height, obj.direction);
            else
                irerror(sprintf('Invalid mode: %d', o.mode));
            end;
            set_title(o.classtitle, obj);

            if o.flag_set_position
                set(gca, 'Position', [0, 0, 1, 1]);
            end;
        end;
    end;
end
