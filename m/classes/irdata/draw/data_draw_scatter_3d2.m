%>@ingroup datasettools
%>@file
%>@brief Draws 3-D scatter plot-ellipse walls

%> @param data dataset
%> @param idxfea What features to use. Numbers point to columns in @c data.X
%> @param confidences a list of percentages (]0, 1[) for the confidence ellipses
%> @param flags_min 3D boolean vector that controls where the walls will be drawn
%> @return <em>[data]</em>
%> @return <em>[data, handles]</em>. handles: handles for the legends
%> @param ks = [0.2, 0.5] a two-element vector with multipliers so that the axis limits take a distance from the points minima and maxima.
%> The first element refers to the minima, and the second refers to the maxima.
%> @param flag_wallpoints = 0. Whether to plot the point projections onto the walls
function varargout = data_draw_scatter_3d2(data, idxfea, confidences, flags_min, ks, flag_wallpoints)

if ~exist('confidences', 'var')
    confidences = [];
end;

if ~exist('flags_min', 'var')
    flags_min = [0, 0, 1];
end;

if ~exist('ks', 'var')
    ks = [0.2, 0.5];
end;

if ~exist('flag_wallpoints', 'var')
    flag_wallpoints = 0;
end;
    

if numel(idxfea) < 3
    irerror('idx_fea must have 3 elements!');
end;
if any(idxfea > data.nf)
    irerror(sprintf('Dataset has only %d feature(s)!', data.nf));
end;

handles = draw3d2_core(data, idxfea, confidences, flags_min, ks, flag_wallpoints);
legend(handles, data_get_legend(data));
draw3d2_adjust(data, idxfea, flags_min, ks);


if nargout <= 1
    varargout = {data};
elseif nargout == 2
    varargout = {data, handles};
end;
