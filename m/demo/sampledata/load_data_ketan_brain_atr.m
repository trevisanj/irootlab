%>@brief Loads Ketan's brain cancer dataset
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_ketan_brain_atr()
varargout = {load_sampledata('ketan_brain_atr.mat', nargout <= 0)};

