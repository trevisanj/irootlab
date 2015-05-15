%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref clus_hca
%>
%>@image html Screenshot-uip_clus_hca.png
%>
%> <b>Minimum number of clusters</b> - see clus_hca::nc_min
%>
%> <b>Maximum number of clusters</b> - see clus_hca::nc_max
%>
%> <b>Distance type</b> - see clus_hca::distancetype
%>
%> <b>Linkage type</b> - see clus_hca::linkagetype
%>
%>@sa clus_hca

%>@cond
function varargout = uip_clus_hca(varargin)
% Last Modified by GUIDE v2.5 23-Jun-2011 04:09:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clus_hca_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clus_hca_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before uip_clus_hca is made visible.
function uip_clus_hca_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_clus_hca_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)

v1 = get(handles.popupmenu_distancetype, 'String');
s1 = v1{get(handles.popupmenu_distancetype, 'Value')};
v2 = get(handles.popupmenu_linkagetype, 'String');
s2 = v2{get(handles.popupmenu_linkagetype, 'Value')};

handles.output.params = {...
'nc_min', int2str(eval(get(handles.edit_nc_min, 'String'))), ...
'nc_max', int2str(eval(get(handles.edit_nc_max, 'String'))), ...
'distancetype', ['''', s1, ''''], ...
'linkagetype', ['''', s2, ''''], ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();


function edit_nc_min_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_nc_min_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nc_max_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_nc_max_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_distancetype.
function popupmenu_distancetype_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_distancetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_distancetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_linkagetype.
function popupmenu_linkagetype_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_linkagetype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
