%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref aggr
%>
%> <b>Estimaton aggregator</b> - see aggr::esag
%>
%> <b>Record the estimations from the individual component classifiers<b> - see aggr::flag_ests
%>
%> @sa @ref aggr

%> @cond
function varargout = uip_aggr(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_aggr_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_aggr_OutputFcn, ...
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

% --- Executes just before uip_aggr is made visible.
function uip_aggr_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
listbox_load_from_workspace('esag', handles.popupmenu_esag, 1);


% --- Outputs from this function are returned to the command line.
function varargout = uip_aggr_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject); % Handles is not a handle(!), so gotta retrieve it again to see changes in .output
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;



% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    sesag = listbox_get_selected_1stname(handles.popupmenu_esag);
    if isempty(sesag)
        sesag = '[]';
    end;

    handles.output.params = {...
    'esag', sesag, ...
    'flag_ests', int2str(get(handles.checkbox_flag_ests, 'Value')) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_esag.
function popupmenu_esag_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_esag_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_no_bagreps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_bagreps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_flag_ests.
function checkbox_flag_ests_Callback(hObject, eventdata, handles)
%> @endcond
