%> @ingroup guigroup
%> @file
%> @brief Properties window for @ref fcon_mea_pick
%> @image html Screenshot-uip_fcon_mea_pick.png
%
%> <b>Type</b> - see fcon_mea_pick::type
%>
%>
%> @sa fcon_mea_pick

%> @cond
function varargout = uip_fcon_mea_pick(varargin)
% Last Modified by GUIDE v2.5 15-Sep-2011 16:58:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fcon_mea_pick_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fcon_mea_pick_OutputFcn, ...
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

% --- Executes just before uip_fcon_mea_pick is made visible.
function uip_fcon_mea_pick_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin >= 5
    handles.inputdataset = varargin{2};
else
    handles.inputdataset = [];
end;

guidata(hObject, handles);
gui_set_position(hObject);

refresh(handles);
handles = guidata(handles.figure1);
view1(handles);

handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_fcon_mea_pick_OutputFcn(hObject, eventdata, handles) 
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

%############################################

%#########
function view1(handles)
cla(handles.axes2, 'reset');
axes(handles.axes2);
ds = handles.dataset;
hold off;
if ~isempty(ds)
    obsidx = eval(get(handles.edit_obsidx, 'String'));
    o = fcon_mea_pick();
    eval(['o = o.setbatch(', params2str(get_params(handles)), ');']);
    try
        o.illustrate(ds, obsidx);
    catch ME
        irerrordlg(ME.message, 'Error');
    end;
else
    msgbox('Cannot draw, input not specified!');
end;

%#########
function refresh(handles)
if ~isempty(handles.inputdataset)
    ss = 'input dataset';
else
    ss = 'leave blank';
end;
listbox_load_from_workspace('irdata', handles.popupmenu_data, 1, ss);
assign_dataset(handles);


%#########
function assign_dataset(handles)

sdata = listbox_get_selected_1stname(handles.popupmenu_data);
if isempty(sdata)
    if ~isempty(handles.inputdataset)
        handles.dataset = handles.inputdataset;
    else
        handles.dataset = [];
    end;
else
    handles.dataset = evalin('base', [sdata, ';']);
end;

guidata(handles.figure1, handles);


%#########
function params = get_params(handles)
% 'm' and 'a'(maximum and area) types require two elements in the location/range vector
idx2 = [2, 3]; % Radio button indexes that require 2 elements in the vector

types = 'fma'; % fixed; maximum; area
    
idx_term = get(get(handles.uipanel_term, 'SelectedObject'), 'UserData');
type = types(idx_term);

v = eval(get(handles.edit_v, 'String'));

if any(idx_term == idx2)
    if numel(v) < 2
        irerror('Coordinate vector requires two elements!');
    end;
end;

params = {...
'v', mat2str(v), ...
'type', ['''', type, ''''] ...
};

%############################################
%############################################



% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;




% --- Executes on button press in pushbuttonView.
function pushbuttonView_Callback(hObject, eventdata, handles)
view1(handles);

% --- Executes on selection change in popupmenu_data.
function popupmenu_data_Callback(hObject, eventdata, handles)
assign_dataset(handles);
view1(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_obsidx_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_obsidx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_v_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_v_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%> @endcond
