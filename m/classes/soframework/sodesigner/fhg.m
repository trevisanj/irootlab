%> FHG - Feature Histogram Generator
%>
%> <h3>Stabilization</h3>
%> It is not obvious how data is used in either case (i.e., with/without stabilization). So, this is explained in detail.
%> @arg Without stabilization, the dataset that reaches the fselrepeater will be split (probably 90%-10%) guided by the cubeprovider::get_sgs_fhg()
%>      SGS, so that the FSG will receive 2 datasets;
%> @arg With stabilization, the FSG will receive the same dataset, but its SGS property will be set, so it will ignore the 10% and will sub-sample the
%>      90% for an averaged performance estimation.
classdef fhg < sodesigner
    methods
        function o = customize(o)
            o = customize@sodesigner(o);
        end;
    end;
    
    methods(Abstract)
        as_fsel = get_as_fsel(o, ds, dia);
    end;
    
    methods
        %> Must return a unique string describing the FHG methodology. Defaults to <code>class(o)</code>
        function [s, s2] = get_s_setup(o, dia) %#ok<INUSD>
            s = upper(class(o));
            s2 = '';
        end;
    end;
    
    % Bit lower level
    methods(Access=protected)
        function out = do_design(o)
            item = o.input;
            dia = item.get_modifieddia();
            ds = o.oo.dataloader.get_dataset();
            ds = dia.preprocess(ds);

            % Creates all those objects
            sgs = o.oo.cubeprovider.get_sgs_fhg();

            ah = fselrepeater(); 
            ah.sgs = sgs;
            ah.fext = pre_std();
            ah.flag_parallel = o.oo.flag_parallel;
            ah.as_fsel = o.get_as_fsel(ds, dia);
            log = ah.use(ds);
            
            out = soitem_fhg();
            out.log = log;
            out.dia = dia;
            out.stab = o.oo.cubeprovider.no_reps_stab;
            out.s_setup = o.get_s_setup(dia);
            out.dstitle = ds.title;
            out.dstitle = ds.title;
            out.title = [out.s_setup, ...
                         iif(out.stab >= 0, sprintf('stab%02d', o.oo.cubeprovider.no_reps_stab), '')...
                         ': Does the sequence description look right? --- ', out.dia.get_s_sequence([], 0)];
% @todo I put this tag above because it is unlikely that the sequence descrption will show what we want to see (e.g. ....->FFS->LDC)
% Sort everything out once tested
        end;        
    end;
end
