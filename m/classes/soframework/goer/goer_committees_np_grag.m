classdef goer_committees_np_grag < goer_ni
    methods
        %> Constructor
        function o = setup(o)
            o.classname = 'committees_np';
        end;

        function d = customize_session(o, d)
            d.oo.cubeprovider.flag_grag = 1;
        end;
    end;
end
