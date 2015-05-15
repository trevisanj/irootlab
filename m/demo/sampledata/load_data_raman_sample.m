%>@brief Loads sample data raman_sample.mat
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_raman_sample()
varargout = {load_sampledata('raman_sample.mat', nargout <= 0)};

