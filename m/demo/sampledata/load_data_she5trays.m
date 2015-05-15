%>@brief Loads sample data she5trays.mat
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_she5trays()
varargout = {load_sampledata('she5trays.mat', nargout <= 0)};

