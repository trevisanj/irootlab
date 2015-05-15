%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref pre_bc_poly
%>
%>@image html Screenshot-uip_pre_bc_poly.png
%>
%> <b>Polynomial order</b> - see pre_bc_poly::order
%>
%> <b>epsilon</b> - see pre_bc_poly::epsilon
%>
%> <b>Dataset with background (contaminant) spectra</b> - see pre_bc_poly::contaminant_data
%>
%> <b>Index(es) of background spectrum(spectra) in dataset</b> - see pre_bc_poly::contaminant_idxs
%>
%> @sa pre_bc_poly

%>@cond
function varargout = blockuip_fsel_fixed(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blockuip_fsel_fixed_OpeningFcn, ...
                   'gui_OutputFcn',  @blockuip_fsel_fixed_OutputFcn, ...
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


% --- Executes just before blockuip_fsel_fixed is made visible.
function blockuip_fsel_fixed_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

ds_refresh(handles);


% --- Outputs from this function are returned to the command clae.
function varargout = blockuip_fsel_fixed_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;


%###################################################
%###################################################

%#########
function ds_refresh(handles)
vars = evalin('base', 'who(''ds*'')');
if ~isempty(vars)
    vars = ['(None)' vars'];
else
    vars = {'(None)'};
end;
set(handles.popupmenuData, 'String', vars);


%###################################################
%###################################################


function editReg_Callback(hObject, eventdata, handles)
% hObject    handle to editReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editReg as text
%        str2double(get(hObject,'String')) returns contents of editReg as a double


% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editReg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.popupmenuData, 'String');

ds_name = a{get(handles.popupmenuData, 'Value')};
if strcmp(ds_name, '(None)')
    ds_name = '[]';
end;


handles.output.params = {...
'order', num2str(eval(get(handles.edit_order, 'String'))), ...
'epsilon', num2str(eval(get(handles.edit_epsilon, 'String'))), ...
'contaminant_data', ds_name, ...
'contaminant_idxs', mat2str(eval(get(handles.editIdxs, 'String'))) ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();



function editKnots_Callback(hObject, eventdata, handles)
% hObject    handle to editKnots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editKnots as text
%        str2double(get(hObject,'String')) returns contents of editKnots as a double


% --- Executes during object creation, after setting all properties.
function editKnots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editKnots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editHelp_Callback(hObject, eventdata, handles)
% hObject    handle to editHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHelp as text
%        str2double(get(hObject,'String')) returns contents of editHelp as a double


% --- Executes during object creation, after setting all properties.
function editHelp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_order_Callback(hObject, eventdata, handles)
% hObject    handle to edit_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_order as text
%        str2double(get(hObject,'String')) returns contents of edit_order as a double


% --- Executes during object creation, after setting all properties.
function edit_order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_epsilon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epsilon as text
%        str2double(get(hObject,'String')) returns contents of edit_epsilon as a double


% --- Executes during object creation, after setting all properties.
function edit_epsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_no_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to edit_no_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_no_iterations as text
%        str2double(get(hObject,'String')) returns contents of edit_no_iterations as a double


% --- Executes during object creation, after setting all properties.
function edit_no_iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_no_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuData.
function popupmenuData_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuData


% --- Executes during object creation, after setting all properties.
function popupmenuData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editIdxs_Callback(hObject, eventdata, handles)
% hObject    handle to editIdxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editIdxs as text
%        str2double(get(hObject,'String')) returns contents of editIdxs as a double


% --- Executes during object creation, after setting all properties.
function editIdxs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editIdxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
