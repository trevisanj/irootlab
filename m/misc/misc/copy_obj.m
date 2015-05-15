%> @file
%>@ingroup misc
%>@brief Shallow copy of object.
function o2 = copy_obj(o)
pp = properties(o);
o2 = eval(class(o));
for i = 1:length(pp)
    o2.(pp{i}) = o.(pp{i});
end;
