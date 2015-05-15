%> @brief converts colors to a map to be used by @ref draw_stacked.m
%> @file
%> @ingroup graphicsapi conversion
%
%> @param colors =(default colors). Can be a cell of 2 elements, 3 elements or 4 elements.
%>   @arg 2 elements: {informative color | [] | "colormap name", non-informative color}
%>   @arg 3 elements: {[] | "colormap name", non-informative color start, non-informative color end}
%>   @arg 4 elements: {informative color start, informative color end, non-informative color start, non-informative color end}
%> @note the empty cases ("[]") mean that find_color_stackedhist() will be used; the 3-element case only accepts an empty first element
%
%> @param no_hists
%> @param no_informative
%> @return <code>[cm, leg_cm, leg_la]</code> @cm is a color map with @c no_hists rows; @c leg_cm is a color map with repeating colors grouped;
%>         @c leg_la are the legend labels that correspond to @c leg_cm
function [cm, leg_cm, leg_la] = colors2map(colors, no_hists, no_informative)
%==============
% Makes colormap and legends simultaneously
if numel(colors) == 3 || isempty(colors{1}) || ischar(colors{1})
    % note that here, colors may be 2- or 3-element
    
    if isempty(colors{1})
        for i = 1:no_informative
            cm(i, :) = rgb(find_color_stackedhist(i));
        end;
    else
        cm = feval(colors{1}, no_informative);
    end;
    
    leg_cm = cm;
    leg_la = arrayfun(@int2ord, 1:no_informative, 'UniformOutput', 0);
    
    
    flag_gradient = numel(colors) > 2;
    if no_informative < no_hists
       if ~flag_gradient 
            cm = [cm; ones(no_hists-no_informative, 1)*colors{2}];
            leg_cm = [leg_cm; colors{2}];
            leg_la = [leg_la, iif(no_informative < no_hists-1, sprintf('%s-%s', int2ord(no_informative+1), int2ord(no_hists)), int2ord(no_hists))];
        else
            for i = 1:3
                cm(no_informative+1:no_hists, i) = linspace(colors{2}(i), colors{3}(i), no_hists-no_informative);
            end;
            leg_cm = cm;
            leg_la = arrayfun(@int2ord, 1:no_hists, 'UniformOutput', 0);
       end;
    end;

else
    % Note that here, colors may be 2- or 4-element
    
    flag_gradient = numel(colors) > 2;

    if ~flag_gradient
        % 2-element
        cm = ones(no_informative, 1)*colors{1};
        if no_informative < no_hists
            cm = [cm; ones(no_hists-no_informative, 1)*colors{2}];
        end;
        
        leg_cm(1, :) = colors{1};
        leg_la = {iif(no_informative > 1, sprintf('%s-%s', int2ord(1), int2ord(no_informative)), int2ord(1))};
        if no_informative < no_hists
            leg_cm(2, :) = colors{2};
            leg_la{2} = iif(no_informative < no_hists-1, sprintf('%s-%s', int2ord(no_informative+1), int2ord(no_hists)), int2ord(no_hists));
        end;
        
    else
        % 4-element
        
        for i = 1:3
            cm(1:no_informative, i) = linspace(colors{1}(i), colors{2}(i), no_informative);
        end;
        
        if no_informative < no_hists
            for i = 1:3
                cm(no_informative+1:no_hists, i) = linspace(colors{3}(i), colors{4}(i), no_hists-no_informative);
            end;
        end;

        leg_cm = cm;
        leg_la = arrayfun(@int2ord, 1:no_hists, 'UniformOutput', 0);
    end;
end;
