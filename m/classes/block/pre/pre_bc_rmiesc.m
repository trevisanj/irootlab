%> @brief Paul Bassan's Resonant Mie Scattering Correction
%>
%> <h3>References:</h3>
%> [1] Paul Bassan, Achim Kohler, Harald Martens, Joe Lee, Hugh J. Byrne, Paul Dumas, Ehsan Gazi, Michael Brown, Noel Clarke, Peter Gardner. Resonant Mie Scattering (RMieS) Correction of Infrared Spectra from Highly Scattering Biological Samples (Analyst, DOI:10.1039/B921056C)
%> 
%> [2]	Paul Bassan, Hugh J. Byrne, Frank Bonnier, Joe Lee, Paul Dumas, Peter Gardner. Resonant Mie scattering in Infrared spectroscopy of biological materials – understanding the “dispersion artefact” Analyst, 134 (2009), 1586—1593
%> 
%> [3] Kohler, A.; Sule-Suso, J.; Sockalingum, G. D.; Tobin, M.; Bahrami, F.; Yang, Y.; Pijanka, J.; Dumas, P.; Cotte, M.; Martens, H. "Estimating and correcting Mie scattering in synchrotron based microscopic FTIR spectra by extended multiplicative signal correction (EMSC). " Appl Spectrosc 2008, 62, 259-266.
%> 
%> [4] Martens, H.; Stark, E. "Extended Multiplicative Signal Correction and Spectral Interference Subtraction - New Preprocessing Methods for near- Infrared Spectroscopy." Journal of Pharmaceutical and Biomedical Analysis 1991, 9, 625-635. 
%>
%> @sa uip_pre_bc_rmiesc.m
classdef pre_bc_rmiesc < pre_bc
    properties
        options = [ ...
            0    ;      % 1. Desired resolution, (0 keeps original resolution)
            1000 ;      % 2. Lower wavenumber range (min value is 1000)
            4000 ;      % 3. Upper wavenumber range (max value is 4000)
            1    ;      % 4. Number of iterations
            2    ;      % 5. Mie theory option (smooth or RMieS)
            7    ;      % 6. Number of principal components used (8 recommended)
            2    ;      % 7. Lower range for scattering particle diameter / um
            8    ;      % 8. Upper range for scattering particle diamter / um
            1.1  ;      % 9. Lower range for average refractive index
            1.5  ;      % 10. Upper range for average refractive index
            10   ;      % 11. Number of values for each scattering parameter default 10
            1    ;      % 12. Orthogonalisation, 0 = no, 1 = yes. (1 recommended)
            1   ];      % 13. Which reference spectrum, 1 = Matrigel, 2 = Simulated
    end;

    
    methods
        function o = pre_bc_rmiesc(o)
            o.classtitle = 'RMieSC';
        end;
    end;
    
    methods(Access=protected)
        
        % Applies block to dataset
        function data = do_use(o, data)
            % pre_bc_rmiesc_use(): returns a transformed dataset

            % Ok, let's leave the Matrigel do the job
            [WNout, ZCorr, History] = RMieS_EMSC_v2(data.fea_x, data.X, o.options); %, feax, mean(X));

            data.fea_x = WNout(end:-1:1)';
            data.X = ZCorr(:, end:-1:1);
        end;
    end;
end