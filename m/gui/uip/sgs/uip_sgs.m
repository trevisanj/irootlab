%> @ingroup guigroup
%> @file
%> @brief Properties Window common to all @ref sgs classes
%>
%> @image html Screenshot-uip_sgs.png
%>
%> <b>Always keep together rows from the same group</b> - see sgs::flag_group
%>
%> <b>Perform on each class separately, then merge</b> - see sgs::flag_perclass
%>
%> <b>Random sees</b> - see sgs::randomseed
%>
%> @sa @ref sgs
%
%> @cond
function varargout = uip_sgs(varargin)
% Last Modified by GUIDE v2.5 06-May-2011 17:25:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_sgs_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_sgs_OutputFcn, ...
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


% --- Executes just before uip_sgs is made visible.
function uip_sgs_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_sgs_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

function editReg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'flag_group', int2str(get(handles.checkbox_flag_group, 'Value')), ...
    'flag_perclass', int2str(get(handles.checkbox_flag_perclass, 'Value')), ...
    'randomseed', num2str(eval(get(handles.edit_randomseed, 'String'))), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkbox_flag_group.
function checkbox_flag_group_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox_flag_perclass.
function checkbox_flag_perclass_Callback(hObject, eventdata, handles)

function edit_randomseed_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_randomseed_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
