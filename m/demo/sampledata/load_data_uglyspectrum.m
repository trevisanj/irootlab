%>@brief Loads sample data uglyspectrum.mat
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_uglyspectrum()
varargout = {load_sampledata('uglyspectrum.mat', nargout <= 0)};

