%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref pre_wden
%>
%>@image html Screenshot-uip_pre_wden.png
%>
%> <b>Wavelet name</b> - see pre_wden::waveletname
%>
%> <b>Number of decomposition levels</b> - see pre_wden::no_levels
%>
%> <b>Thresholds</b> - see pre_wden::thresholds
%>
%> @sa pre_wden

%>@cond
function varargout = blockuip_fsel_rmiesc(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:29:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @blockuip_fsel_rmiesc_OpeningFcn, ...
                   'gui_OutputFcn',  @blockuip_fsel_rmiesc_OutputFcn, ...
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


% --- Executes just before blockuip_fsel_rmiesc is made visible.
function blockuip_fsel_rmiesc_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = blockuip_fsel_rmiesc_OutputFcn(hObject, eventdata, handles) 
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

handles.output.params = {...
'waveletname', ['''' fel(get(handles.popupmenuWaveletname, 'String')) ''''], ...
'no_levels', int2str(eval(get(handles.editNo_levels, 'String'))), ...
'thresholds', mat2str(eval(get(handles.editThresholds, 'String'))) ...
};

handles.output.flag_ok = 1;
guidata(hObject, handles);
uiresume();



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



function editNo_levels_Callback(hObject, eventdata, handles)
% hObject    handle to editNo_levels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNo_levels as text
%        str2double(get(hObject,'String')) returns contents of editNo_levels as a double


% --- Executes during object creation, after setting all properties.
function editNo_levels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNo_levels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuWaveletname.
function popupmenuWaveletname_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuWaveletname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuWaveletname contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuWaveletname


% --- Executes during object creation, after setting all properties.
function popupmenuWaveletname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuWaveletname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editThresholds_Callback(hObject, eventdata, handles)
% hObject    handle to editThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThresholds as text
%        str2double(get(hObject,'String')) returns contents of editThresholds as a double


% --- Executes during object creation, after setting all properties.
function editThresholds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
