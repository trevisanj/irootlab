%> FHG - Feature Histogram Generator - set for a univariate Feature Selection using the Fisher criterion
%>
%>
classdef fhg_fisher < fhg
    methods
        function as = get_as_fsel(o, ds, dia) %#ok<*INUSD>
            pd = peakdetector();
            pd.mindist_units = 30;
            pd.no_max = 0;
            
            af = as_grades_fsg();
            af.fsg = fsg_test_fisher();
            
            ag = as_fsel_grades();
            ag.nf_select = o.oo.fhg_fisher_nf_select;
            ag.peakdetector = pd;
            
            as = as_fsel_grades_super();
            as.as_grades_data = af;
            as.as_fsel_grades = ag;
        end;
    end;
end
