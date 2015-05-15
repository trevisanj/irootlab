%> Feature Extraction Design - Univariate Feature Selection using the Fisher criterion
%>
%>
classdef fearchsel_fisher < fearchsel_fs_base
    methods
        %> Constructor
        function o = fearchsel_fisher()
            o.classtitle = 'FS_Fisher';
        end;

        function as = get_as_fsel(o, ds, dia) %#ok<*INUSD>
            pd = peakdetector();
            pd.mindist_units = 30;
            pd.no_max = 0;


            af = as_grades_fsg();
            af.fsg = fsg_test_fisher();
            
            ag = as_fsel_grades();
            ag.nf_select = o.oo.fearchsel_fisher_nf_max;
            ag.peakdetector = pd;
            
            as = as_fsel_grades_super();
            as.as_grades_data = af;
            as.as_fsel_grades = ag;
        end;        
    end;    
end
