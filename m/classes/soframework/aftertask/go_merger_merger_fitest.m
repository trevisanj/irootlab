%> Runs a @ref goer_merger_merger_fit
%>
%> 
%>
%> <h3>Important</h3>
%> If your directory does not have a file named "sosetup_scene.m", you can create one with the following contents:
%> @code
%> function o = sosetup_scene()
%> o = sosetup();
%> @endcode
%>
%> @param fns_input Cannot be optional, as there are different grouping options (e.g. by feature extraction; by classifier; only non-pairwise cases etc)
%> @param fn_output (optional). Defaults to "output_merger_merger_fitest.mat"
function go_merger_merger_fitest(fns_input, fn_output)
if nargin < 2
    fn_output = 'output_merger_merger_fitest.mat';
end;

if exist(fn_output, 'file')
    delete(fn_output);
end;


o = goer_merger_merger_fitest();
o.fns_input = fns_input;
o.fn_output = fn_output;
o.go();
