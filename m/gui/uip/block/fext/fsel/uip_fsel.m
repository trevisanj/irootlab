%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fsel
%>
%> <b>Variables</b> - see fsel::v
%>
%> <b>Meaning of "Variables" above (1)</b> - How to interpret the vector given in the first box. See fsel::v_type
%>
%> <b>Meaning of "Variables" above (2)</b> - Whether to keep or to exclude the variables specified. See fsel::flag_complement
%>
%> @sa fsel

%>@cond
function varargout = uip_fsel(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fsel_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fsel_OutputFcn, ...
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


% --- Executes just before uip_fsel is made visible.
function uip_fsel_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_fsel_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;



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

flag_complement = strcmp(get(get(handles.uipanel_flag_complement, 'SelectedObject'), 'Tag'), 'radiobutton_exclude');
v_type = get(get(handles.uipanel_v_type, 'SelectedObject'), 'Tag');
v_type = v_type(13:end); % The suffixes match the "v_type" parameter of data_select_features()

handles.output.params = {...
'v_type', ['''' v_type ''''], ...
'flag_complement', int2str(flag_complement), ...
'v', get(handles.editVariables, 'String') ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();



function editVariables_Callback(hObject, eventdata, handles)
% hObject    handle to editVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVariables as text
%        str2double(get(hObject,'String')) returns contents of editVariables as a double


% --- Executes during object creation, after setting all properties.
function editVariables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVariables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
