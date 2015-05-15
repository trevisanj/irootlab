%>@brief Loads the hint dataset: this dataset containg one spectrum only: 1800-900 cm^-1
%>@file
%>@ingroup demo sampledata
%>
%> This dataset containg one spectrum only 1800-900 cm^-1
%
%> @return A dataset
function varargout = load_data_hint()
varargout = {load_sampledata('hintdataset.mat', nargout <= 0)};

