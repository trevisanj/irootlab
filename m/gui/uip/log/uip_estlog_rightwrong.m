%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref estlog_rightwrong
%>
%> <b>Title</b> Title needs to be a valid MATLAB field name (if the log will be ever used to build a @ref sovalues). A default random title is automatically generated.
%>
%> @sa estlog_rightwrong

%> @cond
function varargout = uip_estlog_rightwrong(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_estlog_rightwrong_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_estlog_rightwrong_OutputFcn, ...
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

% --- Executes just before uip_estlog_rightwrong is made visible.
function uip_estlog_rightwrong_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
set(handles.edit_title, 'string', sprintf('rightwrong%03d', randi([1, 999])));


% --- Outputs from this function are returned to the command line.
function varargout = uip_estlog_rightwrong_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;



% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'title', ['''', get(handles.edit_title, 'String'), ''''], ...
    'flag_support', int2str(get(handles.checkbox_flag_support, 'Value')), ...
    'estlabels', get(handles.edit_estlabels, 'String'), ...
    'idx_rate', int2str(get(handles.popupmenu_idx_rate, 'Value')), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function checkbox_flag_support_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
function edit_title_Callback(hObject, eventdata, handles)
function edit_title_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_estlabels_Callback(hObject, eventdata, handles)
function edit_estlabels_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%#####
function pushbutton_pick_Callback(hObject, eventdata, handles)
ouch = ask_dataset([], 'Dataset to pick class labels from', 0);
if ouch.flag_ok
    set(handles.edit_estlabels, 'String', [ouch.params{2}, '.classlabels']);
end;

%-----------------------------------------------------------------------------------------------------

function popupmenu_idx_rate_Callback(hObject, eventdata, handles)
function popupmenu_idx_rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
