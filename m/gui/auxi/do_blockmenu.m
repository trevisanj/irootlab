%>@ingroup misc
%> @file
%> @brief Create [and apply] block

%> @return result from @c blockmenu() with an additional @c og field which is an already set @c codegen object.
function result = do_blockmenu(classname, dsnames, flag_leave_block)

if ~exist('dsnames', 'var')
    dsnames = [];
end;
if ~exist('flag_leave_block', 'var')
    flag_leave_block = 1;
end;

result = blockmenu(classname, dsnames);

if result.flag_ok
    og = gencode();
    og.classname = result.classname;
    og.dsnames = dsnames;
    og.params = result.params;
    og.flag_leave_block = flag_leave_block;
    result.og = og;
end;
