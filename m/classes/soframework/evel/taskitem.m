%> Container for a task definition
classdef taskitem
    properties
        id;
        idscene;
        idx;
        status;
        who;
        classname;
        fns_input;
        fn_output;
        ovrindex;
        cvsplitindex;
        dependencies;
        tries;
        failedreports;
        stabilization;
    end;
end