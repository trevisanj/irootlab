classdef goer_committees_np < goer_ni
    methods
        %> Constructor
        function o = setup(o)
            o.classname = 'committees_np';
        end;

        function d = customize_session(o, d)
            d.oo.cubeprovider.flag_grag = 0;
        end;
    end;
end
