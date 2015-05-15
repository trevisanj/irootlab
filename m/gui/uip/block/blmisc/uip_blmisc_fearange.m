%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref blmisc_fearange
%> @sa blmisc_fearange

%>@cond
function varargout = uip_blmisc_fearange(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_blmisc_fearange_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_blmisc_fearange_OutputFcn, ...
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


% --- Executes just before uip_blmisc_fearange is made visible.
function uip_blmisc_fearange_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin > 4
    % Dataset is expected as parameter
    ds = varargin{2};
    set(handles.edit_range, 'String', mat2str([ds.fea_x(1), ds.fea_x(end)]));
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_blmisc_fearange_OutputFcn(hObject, eventdata, handles) 
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

handles.output.params = {...
'range', get(handles.edit_range, 'String') ...
};
handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();



function edit_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_range as text
%        str2double(get(hObject,'String')) returns contents of edit_range as a double


% --- Executes during object creation, after setting all properties.
function edit_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%>@endcond
