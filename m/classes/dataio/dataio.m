%> @brief Dataset loader/saver common class
classdef dataio < irobj
    properties(Constant)
        defaultrange = [1801.47, 898.81];
    end
    
    properties
        filename = '';
    end;
    
    properties(SetAccess=protected)
        flag_xaxis = 1;
    end;
    
    methods
        function o = dataio()
            o.flag_params = 0;
        end;
        function data = load(filename, range)
        end
        function save(data, filename)
        end
    end
end