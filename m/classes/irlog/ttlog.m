%> @brief Train-Test Log.
%>
%> Base class for objects that have the record(pars) method. Pars may contain a reference dataset; an estimation dataset; a block; ...
classdef ttlog < irlog
    properties
        %> =1. Whether to increment time whenever something is recorded
        flag_inc_t = 1;
    end;
    
    properties(SetAccess=protected)
        %> Whether @c allocate() has been called.
        flag_allocated = 0;
        %> Number of allocated slots (call to allocate())
        no_slots = 0;
    end;

    methods(Access=protected) %, Abstract)
        %> Abstract. Called to pre-allocate matrices. Must be called only when @c collabels and @c rowlabels can be resolved
        %> (reaching this varies along @c ttlog descendants).
        function o = do_allocate(o, tt)
        end;
    end;

    properties %(SetAccess=protected)
        %> "Time", incremented every time @c record() is called. Reset to zero if @c allocate() is called.
        t = 0;
    end;

    
    methods
        function o = ttlog(o)
            o.classtitle = 'Train-Test';
            o.flag_params = 0;
            o.moreactions{end+1} = 'extract_datasets';
        end;
        
        %> @param pars Structure with varying fields: @c .ds_test ; %c .est ; @c .clssr .
        function o = record(o, pars) %#ok<*INUSD>
        end;
        
        %> Called to pre-allocate matrices after @c classlabels and @c rowlabels are set
        function o = allocate(o, tt)
%             fprintf('Chamando o allocate, sim\n');
            o.t = 0;
            o = o.do_allocate(tt);
            o.flag_allocated = 1;
            o.no_slots = tt;
        end;
        
        %> Abstract.
        function s = get_insane_html(o, pars)
            s = '';
        end;
        
        %> Abstract. Generates one dataset per row, containing percentages.
        function dd = extract_datasets(o)
            dd = [];
        end;
        
        %> Returns the default "Rate" string. Note that the @c title property can be used.
        function z = get_legend(o)
            if ~isempty(o.title)
                z = o.title;
            else
                z = 'Rate';
            end;
        end;
        
        %> Returns the "default" peformance measure, to be customizable. It is "abstract" in this class (returns zero)
        %>
        %> Note that "rate" is defined in the range 0-100, not 0-1
        function z = get_rate(o)
            z = 0;
        end;
        
       
        %> Returns the unit corresponding to what it returns as rate
        function z = get_unit(o)
            z = 'a.u.';
        end;
        
        %> Returns format for sprintf()
        function z = get_format(o)
            z = '%f';
        end;
    end;
end
