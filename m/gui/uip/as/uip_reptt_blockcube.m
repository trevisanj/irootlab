%> @ingroup guigroup
%> @file
%> @brief Properties Window for a @ref reptt_blockcube
%> @sa reptt_blockcube

%> @cond
function varargout = uip_reptt_blockcube(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_reptt_blockcube_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_reptt_blockcube_OutputFcn, ...
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

% --- Executes just before uip_reptt_blockcube is made visible.
function uip_reptt_blockcube_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 1);


% --- Outputs from this function are returned to the command line.
function varargout = uip_reptt_blockcube_OutputFcn(hObject, eventdata, handles) 
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
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
        ssgs = '[]'; %error('SGS not specified!');
    end;

    other = uip_reptt();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'sgs', ssgs, ...
        'flag_parallel', int2str(get(handles.checkbox_flag_parallel, 'value')), ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');   
end;

function popupmenu_sgs_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>

function popupmenu_sgs_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function checkbox_flag_parallel_Callback(hObject, eventdata, handles)
%> @endcond
