%> @brief Draws entropy curves based on a as_fsel_hist object
%>
%> @todo this is obsolete. Should take log_hist as input, not as_fsel_hist (which doesn't exist anymore)
classdef vis_as_fsel_hist_entropy < vis
    properties
        %> ={[Inf, 0, 0], [1, 2]}
        %> @sa sovalues.m
        dimspec = {[Inf, 0, 0], [1, 2]};
        
        %> =rates
        valuesfieldname = 'rates';
        
        %> =1.
        flag_legend;
        
        %> =[]
        ylimits;
        
        %> =[]
        xticks;
        
        %> =[]
        xticklabels;

        %>
        flag_star = 1;
        
        flag_hachure = 0;
    end;
    
    
    methods
        %> Constructor
        function o = vis_as_fsel_hist_entropy(o) %#ok<*INUSD>
            o.classtitle = 'Entropy curves';
            o.inputclass = 'as_fsel_hist';
        end;
    end;
    

    methods(Access=protected)
        function out = do_use(o, a)
            out = [];
                            
            % Plots entropies both individual and accumulated hitss
            subplot(1, 2, 1);
            plot(hitsentropy(a.hitss, 'uni'), 'LineWidth', scaled(2.5));
            title('Entropy of each histogram');
            format_frank();
            make_box();
            
            subplot(1, 2, 2);
            plot(hitsentropy(a.hitss, 'accum'), 'LineWidth', scaled(2.5));
            title('Entropy of accumulated histogram');
            format_frank(); 
            make_box();
        end;
    end;
end
