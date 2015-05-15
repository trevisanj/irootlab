%>@brief Loads Matt's synchrotron data (5 spectra only)
%>@file
%>@ingroup demo sampledata
%
%> @return A dataset
function varargout = load_data_matt_nanoparticles_synchrotron()
varargout = {load_sampledata('matt_nanoparticles_synchrotron.mat', nargout <= 0)};

