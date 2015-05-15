%> Runs a @ref goer_merger_merger_fhg
%>
%> Scans directory for results MAT files containing a soitem_merge_fhg inside. Assigns these items as inputs for a @ref goer_merger_merger_fhg,
%> and runs it subsequently to generate a file called "outpuer_merger_merger_fhg.mat"
%>
%> <h3>Important</h3>
%> If your directory does not have a file named "sosetup_scene.m", you can create one with the following contents:
%> @code
%> function o = sosetup_scene()
%> o = sosetup();
%> @endcode
%>
function go_merger_merger_fhg()
fn_output = 'soout_merger_merger_fhg.mat';

if exist(fn_output, 'file')
    delete(fn_output);
end;

d = dir('*.mat');

fns = {};
for i = 1:numel(d)
    name = d(i).name;
    clear r;
    load(name);
    if exist('r', 'var')
        if isa(r.item, 'soitem_merger_fhg')
            irverbose(sprintf('Including file "%s"', name));
            fns{end+1} = name;
        end;
    end;
end;

o = goer_merger_merger_fhg();
o.fns_input = fns;
o.fn_output = fn_output;
o.go();
