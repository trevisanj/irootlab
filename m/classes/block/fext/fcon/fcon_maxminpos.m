%> @brief Maxima/minima detection
%>
%> Finds several maxima/minima within several ranges specified by the @c map property. The new variables will contain the values of the x-axis positions (wavenumbers) of each minimum/maximum detected.
%>
%> <h3>@c map example</h3>
%> @verbatim
%> o.map = [1670, 1620, 0; % Amide I
%>          1560, 1500, 0; % Amide II
%>          1468, 1435, 0; % Proteins
%>          1418, 1380, 0; % Proteins
%>          1260, 1215, 0; % Amide III
%>          1120, 1040, 0; % Various DNA/RNA
%>         ]
%> @endverbatim
%
%> Uses peak_landmarks.m to convert multiple peak locations into features
%> @sa peak_landmarks.m
classdef fcon_maxminpos < fcon
    properties
        %> [wn11, wn12, flag_min1; wn21, wn22, flag_min2; ...]
        map = [];
    end;

    methods
        function o = fcon_maxminpos(o)
            o.classtitle = 'Maxima/minima Detection';
        end;
    end;
    
    methods(Access=protected)
        function data = do_use(o, data)

            % Converts ranges of o.map (given in wavenumbers) to indexes
            map_idx = o.map;
            map_idx(:, 1:2) = v_x2ind(o.map(:, 1:2), data.fea_x);

            T = peak_landmarks(data.X, map_idx);

            data.X = T;
            data.fea_x = 1:size(T, 2);
        end;
    end;
end
