%>@ingroup idata
%>@file
%> There are class code lower than zero with special meaning:
%> <table>
%    <tr><td><code>>=0</code></td><td>Existing class; refers to element within @ref classlabels property</td>
%    <tr><td><code>-1</code></td><td>"Refuse-to-decide": a classifier wasn't confident enough to assign a class. See @ref decider</td>
%    <tr><td><code>-2</code></td><td>Outlier</td>
%    <tr><td><code>-3</code></td><td>"Refuse-to-cluster". See @ref clus_hca</td>
%    <tr><td><code>-10</code></td><td>not found / error in conversion</td>
%> </table>

%> @param x A value <= -1
function s = get_negative_meaning(x)

if x == -1
    s = 'Refuse-to-decide';
elseif x == -2
    s = 'Outlier';
elseif x == -3
    s = 'Refuse-to-cluster';
elseif x == -10
    s = 'Not found/error in conversion';
elseif x >= 0
    irerror('< 0, please');
else
    irerror(sprintf('Unrecognized: %d', x));
end;
