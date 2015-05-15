%> @brief Normalization - final class
%>
%> Uses normaliz.m to do the job.
%>
%> @sa normaliz.m, uip_pre_norm.m
classdef pre_norm < pre_norm_base
    methods
        function o = pre_norm()
            o.classtitle = 'Normalization';
            o.flag_params = 1;
        end;
    end;

end