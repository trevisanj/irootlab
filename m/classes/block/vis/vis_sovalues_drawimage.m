%> @brief Draws image from a sovalues object
classdef vis_sovalues_drawimage < vis
    properties
        %> ={[Inf, 0, 0], [1, 2]}
        %> @sa sovalues.m
        dimspec = {[Inf, 0, 0], [1, 2]};
        
        %> =rates
        valuesfieldname = 'rates';
        
        %> =[]
        clim = [];
        
        %> =0
        flag_logtake = 0;

        %> =0
        flag_transpose = 0;

        flag_star = 1;
    end;
    
    
    methods
        %> Constructor
        function o = vis_sovalues_drawimage()
            o.classtitle = 'Image';
            o.inputclass = 'sovalues';
        end;
    end;
    

    methods(Access=protected)
        function out = do_use(o, r)
            out = [];

            p = plotter12();
            [p.values, p.ax, axnot] = sovalues.get_vv_aa(r.values, r.ax, o.dimspec);

            
            if ndims(p.values) ~= 2
                irerror('dimspec is wrong, should select exactly 2 dimensions!');
            end;
            
   
            ch = r.chooser;
            if o.flag_star && ~isempty(ch)
                %> Finds the "best" (x, y) to put a star on the image
                temp = ch.use(p.values);
                star_ij= cell2mat(temp);
            else
                star_ij = [];
            end;
            
            p.draw_image(o.valuesfieldname, star_ij, o.clim, o.flag_logtake, o.flag_transpose);
            
            % title
            if numel(axnot) > 0
                s = '';
                for i = 1:numel(axnot)
                    if i > 1
                        s = cat(2, s, '; ');
                    end;
                    s = cat(2, s, axnot(i).label, ': ', axnot(i).ticks{1});
                end;
                
                title(s);
            end;
        end;
    end;
end
