classdef goer_committees_pa_grag < goer_ni
    methods
        %> Constructor
        function o = setup(o)
            o.classname = 'committees_pa';
        end;

        function d = customize_session(o, d)
            d.oo.cubeprovider.flag_grag = 1;
        end;
    end;
end
