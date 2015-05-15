%> @brief Records (1)x([rejected, right, wrong]) hits
%>
%> For right/wrong to be detected, classlabels from estimation and test datasets need to follow same system, which is
%> represented by the @c estlabels property.
classdef estlog_rightwrong < estlog
    properties
        %> All possible class labels in estimation datasets
        estlabels = {};
        %> =2. Index of element: 1-rejected; 2-right; 3-wrong
        idx_rate = 2;
    end;
    
    methods
        function o = estlog_rightwrong()
            o.classtitle = 'Right/Wrong';
            o.flag_params = 1;
        end;
        
        %> Returns average sensitivity. Calculated as normalized sum.
        function z = get_rate(o)
            C = o.get_C([], 1, 2, 1); % Average time-wise percentage with discounted items
            z = C(o.idx_rate);
        end;
        
        %> Returns vector of time-wise averages.
        function z = get_rates(o)
            CC = o.get_C([], 1, 0, 1); % gets time-wise percentage with discounted items
            z = permute(CC(1, o.idx_rate, :), [1, 3, 2]);
        end;
    end;
    
    methods(Access=protected)
        %> Returns fixed {'Right', 'Wrong'} cell.
        function z = get_collabels(o)
            z = {'Right', 'Wrong'};
        end;
        
        %> Returns fixed {'---'} cell.
        function z = get_rowlabels(o)
            z = {'---'};
        end;
        
        function o = do_record(o, pars)
            est = pars.est;
            ds_test = pars.ds_test;
            classes1 = renumber_classes(est.classes, est.classlabels, o.estlabels);
            classes2 = renumber_classes(ds_test.classes, ds_test.classlabels, o.estlabels);
            
            boolc = classes1 == classes2;
            boolr = classes1 == -1;
            no_correct = sum(boolc);
            no_reject = sum(boolr);
            o.hits(:, :, o.t) = [no_reject, no_correct, est.no-no_reject-no_correct];
            
            if o.flag_support
                o.supports(:, :, o.t) = {est.X(boolr, :)', est.X(boolc, :)', est.X(~boolc & ~boolr, :)'};
            end;
        end;
    end;
end
