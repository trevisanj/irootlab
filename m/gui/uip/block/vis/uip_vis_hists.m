%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_hists
%> @sa vis_hists

%>@cond
function varargout = uip_vis_hists(varargin)
% Last Modified by GUIDE v2.5 05-Oct-2011 19:54:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_hists_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_hists_OutputFcn, ...
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


% --- Executes just before uip_vis_hists is made visible.
function uip_vis_hists_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_hists_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    handles.output.params = {...
    'idx_hist', mat2str(eval(get(handles.edit_idx_hist, 'String'))), ...
    'flag_group', int2str(get(handles.checkbox_flag_group, 'Value')) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function edit_idx_hist_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_hist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_flag_group.
function checkbox_flag_group_Callback(hObject, eventdata, handles)

%> @endcond
