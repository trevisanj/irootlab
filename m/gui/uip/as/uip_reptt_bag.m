%> @ingroup guigroup
%> @file
%> @brief Properties Window to create a Cascade Block
%> @image html Screenshot-uip_reptt_bag.png
%>
%> <b>SGS</b> - see reptt_bag::sgs
%>
%> <b>Number of bagging repetitions</b> - see reptt_bag::no_bagreps
%>
%> @sa reptt_bag, reptt, uip_reptt.m

%> @cond
function varargout = uip_reptt_bag(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_reptt_bag_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_reptt_bag_OutputFcn, ...
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

% --- Executes just before uip_reptt_bag is made visible.
function uip_reptt_bag_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 0);


% --- Outputs from this function are returned to the command line.
function varargout = uip_reptt_bag_OutputFcn(hObject, eventdata, handles) 
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
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
        error('SGS not specified!');
    end;

    other = uip_reptt();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'sgs', ssgs, ...
        'no_bagreps', int2str(eval(get(handles.edit_no_bagreps, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)
local_show_description(handles, handles.popupmenu_sgs);

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_no_bagreps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_bagreps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
