%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref clssr_dist
%> @image html Screenshot-uip_clssr_dist.png
%>
%> <b>Type of distance</b> - see clssr_dist::normtype
%>
%> <b>Weigh data points using recursive potential</b> - see clssr_dist::flag_pr
%>
%> @sa @ref clssr_dist

%> @cond
function varargout = uip_clssr_dist(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:40:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_clssr_dist_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_clssr_dist_OutputFcn, ...
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


% --- Executes just before uip_clssr_dist is made visible.
function uip_clssr_dist_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = uip_clssr_dist_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;


% --- Executes on button press in pushbuttonCreate.
function pushbuttonCreate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCreate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

methods = {'euclidean', 'classify'};
method = methods{get(handles.popupmenuMethod, 'Value')};

try
    handles.output.params = {...
        'normtype', ['''' method ''''], ...
        'flag_pr', int2str(get(handles.checkboxPr, 'Value')) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenuMethod.
function popupmenuMethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuMethod


% --- Executes during object creation, after setting all properties.
function popupmenuMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxPr.
function checkboxPr_Callback(hObject, eventdata, handles)
%>@endcond
