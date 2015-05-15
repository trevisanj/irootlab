%> @file
%> @ingroup misc ioio parallelgroup
%> @brief Returns the host name
%>
%> This solution was found on MATLAB Exchance Central
%>
%> Original author: Manuel Marin
function name = get_computer_name();

[ret, name] = system('hostname');

if ret ~= 0,
   if ispc
      name = getenv('COMPUTERNAME');
   else
      name = getenv('HOSTNAME');
   end
end
name = lower(name);

% eliminates CRLF
name(name == 10) = [];
name(name == 13) = [];
