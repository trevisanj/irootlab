%% EXAMPLE TO ILLUSTRATE HOW TO USE THE RMIES_EMSC ALGORITHM
%
% In this example a simple data set is loaded from file
% "Test_data_for_RMieS" which contains:-
%   - WN - a COLUMN vector of the Wavenumber values
%   - ZRaw - a matrix where each ROW is a spectrum
%
% The next section of the code then sets the correction options, followed
% by the actual correction which gives the following outputs:
%   - WN_corr - The Wavenumber vector corresponding to the corrected
%   spectra, needed in case you chose to analyse a specific range at a
%   different resolution.
%   - ZCorr - the corrected spectra matrix
%   - History - a 3D matrix of the history of the corrected spectra for
%   each iteration. The results from iteration 3 for example would be
%   History(:,:,3)
%
%
%
% Written by Paul Bassan, Achim Kohler, Harald Martens, Joe Lee and Peter
% Gardner
%
% Any questions, please email: paul.bassan@postgrad.manchester.ac.uk
%
% Last revised 24/11/09

%% Loading the data etc

clear; close all; clc

load Test_data_for_RMieS


%% Correction options

correction_options = [ ...
    0    ;      % 1. Desired resolution, (0 keeps original resolution)
    1000 ;      % 2. Lower wavenumber range (min value is 1000)
    2300 ;      % 3. Upper wavenumber range (max value is 4000)
    1    ;      % 4. Number of iterations
    2    ;      % 5. Mie theory option (smooth or RMieS)
    8    ;      % 6. Number of principal components used 
    2    ;      % 7. Lower range for scattering particle diameter / um
    8    ;      % 8. Upper range for scattering particle diameter / um
    1.1  ;      % 9. Lower range for average refractive index
    1.5  ;      % 10. Upper range for average refractive index
    10   ;      % 11. Number of values for each scattering parameter (a,b,d) default 10
    1    ;      % 12. Orthogonalisation, 0 = no, 1 = yes. (1 recommended)
    2   ];      % 13. Which reference spectrum, 1 = Matrigel, 2 = Simulated Spectrum


%% The Correction

[WN_corr ZCorr History] = RMieS_EMSC_v2(WN, ZRaw , correction_options);


%% Plotting results

plotp( WN_corr , ZCorr )






















