%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref clssr_ann
%> @image html Screenshot-uip_clssr_ann.png
%>
%> <b>Multiple outputs</b> - see clssr_ann::flag_class2mo
%>
%> <b>Hidden layers setup</b> - see clssr_ann::hiddens
%>
%> @sa @ref clssr_ann

%> @cond
function varargout = uip_clssr_ann(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:42:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clssr_ann_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clssr_ann_OutputFcn, ...
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




% --- Executes just before uip_clssr_ann is made visible.
function uip_clssr_ann_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = uip_clssr_ann_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;



function editHidden_Callback(hObject, eventdata, handles)
% hObject    handle to editHidden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHidden as text
%        str2double(get(hObject,'String')) returns contents of editHidden as a double


% --- Executes during object creation, after setting all properties.
function editHidden_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHidden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbuttonCreate.
function pushbuttonCreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    handles.output.params = {...
    'flag_class2mo', sprintf('%d', get(handles.checkboxFlagClass2MO, 'Value') ~= 0), ...
    'hiddens', get(handles.editHidden, 'String') ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;
%>@endcond
