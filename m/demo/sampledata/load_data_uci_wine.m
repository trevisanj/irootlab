%>@brief Loads sample data userdata_nc2nf2.txt
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_uci_wine()
varargout = {load_sampledata('uci_wine.txt', nargout <= 0)};

