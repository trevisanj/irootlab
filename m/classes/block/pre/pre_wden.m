%> @brief Wavelet De-noising block
%>
%> Wavelet de-noising uses the following techniques:
%> @arg Symmetric signal extension
%> @arg Stationary Wavelet Transform (SWT)
%> @arg Hard Thresholding
%> 
%> The sequence is:
%> signal extension -> SWT decomposition -> thresholding -> SWT reconstruction
%> 
%> The functions used are present in the Wavelet toolbox
%> 
%> Probably the hard part of using this is to figure out the number of levels and the thresholds for each level. For a Raman spectrum, it has been found that 6 levels and the [0, 0, 0, 100, 1000, 1000] thresholds worked fine using a 'haar' wavelet.
%> 
%> You can use the 'interactive_wden' tool to help finding these values.
%> 
%> Alternatively you can use the 'Signal extension' followed by the 'SWT de-noising 1D' tool provided with the Wavelet Toolbox (accessed by typing 'wavemenu') to process one spetrum and get these parameters.
%>
%> See also MATLAB Wavelet Toolbox User's guide
%>
%> @image html "Screenshot-Stationary Wavelet Transform Denoising 1-D-1.png"
%> <center>Figure 1 - Finding thresholds using the utility from the MATLAB Wavelet Toolbox</center>
%> @sa uip_pre_wden.m
classdef pre_wden < pre
    properties
        %> ='haar'
        waveletname = 'haar';
        %> =6
        no_levels = 6;
        %> = [0 0 0 20 20 100] - given in the coarsest-to-finest order
        thresholds = [0 0 0 20 20 100];
    end;

    
    methods
        function o = pre_wden(o)
            o.classtitle = 'Wavelet De-noising';
            o.short = 'WDen';
        end;
    end;
    
    methods(Access=protected)

        %> Applies block to dataset
        function data = do_use(o, data)
            data.X = wden(data.X, o.no_levels, o.thresholds, o.waveletname);
        end;
    end;
end
