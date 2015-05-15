%> @brief Aux function for bmtable
%> @file
%> @ingroup conversion maths
%
%> @param y
%> @param dl "DrawLines"
%> @return yout
function yout = cy(y, dl)
yout = (y-dl.miny)*dl.scale+dl.offset;

