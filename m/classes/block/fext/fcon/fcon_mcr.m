%> @brief Multivariate Curve Resolution
%>
%> Uses the Toolbox from the University of Barcelona (http://www.mcrals.info)
%>
%> The use() method calls an <b>interative</b> function from that toolbox. This <a href="mcr.pdf">configuration</a> was used to obtain the results published in [2].
%>
%> <h3>References</h3>
%>
%> ﻿[1] J. Jaumot, R. Gargallo, a Dejuan, and R. Tauler, “A graphical user-friendly interface for MCR-ALS: a new tool for multivariate curve 
%>resolution in MATLAB,” Chemometr. Intell. Lab., vol. 76, no. 1, pp. 101-110, Mar. 2005.
%>
%> [2] I. I. Patel et al., “High contrast images of uterine tissue derived using Raman microspectroscopy with the empty modelling approach of 
%> multivariate curve resolution-alternating least squares,” Analyst, no. 23, pp. 4950-4959, Dec. 2011.
%>
%> @sa uip_fcon_mcr.m
classdef fcon_mcr < fcon_linear
    properties
        flag_rotate_factors = 1;
        no_factors = 10;
    end;
    
    methods
        function o = fcon_mcr()
            o.classtitle = 'Multivariate Curve Resolution';
            o.short = 'MCR';
            o.flag_trainable = 0;
        end;
    end;
    
    methods(Access=protected)
               
        function out = do_use(o, data)

            % Uses PCA for guess of initial "spectra", but not recommended.
            opca = fcon_pca();
            opca = opca.setbatch({'no_factors', opca.no_factors, ...
            'flag_rotate_factors', 0});
            opca = opca.train(data);

            nfact = size(opca.L, 2);
            [copt,sopt,sdopt,ropt,areaopt,rtopt]=als(data.X, abs(opca.L'), 1, 50, 0.0001, ones(1, nfact), 0, 0, [], []);

            o.L = adjust_unitnorm(sopt');
            
            out = data;
            out.X = copt;
            out.fea_x = 1:size(copt, 2);
        end;
    end;
end