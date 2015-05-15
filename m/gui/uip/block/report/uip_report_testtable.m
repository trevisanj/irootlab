%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_testtable
%>
%> <b>Index of feature to test</b> - see report_testtable::idx_fea
%> <b>Feature Selection Grader (FSG) object</b> - see report_testtable::fsg
%>
%> @sa report_testtable

%>@cond
function varargout = uip_report_testtable(varargin)
% Last Modified by GUIDE v2.5 18-Oct-2012 17:50:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_testtable_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_testtable_OutputFcn, ...
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


% --- Executes just before uip_report_testtable is made visible.
function uip_report_testtable_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

function varargout = uip_report_testtable_OutputFcn(hObject, eventdata, handles) 
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
function refresh(handles)
listbox_load_from_workspace('fsg', handles.popupmenu_fsg, 1);
fsg = def_fsg_testtable();
set(handles.text_fsg, 'String', sprintf('Feature subsets grader (defaults to a %s)', fsg.classtitle));

%############################################


% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sfsg = listbox_get_selected_1stname(handles.popupmenu_fsg);
    if isempty(sfsg)
        sfsg = 'fsg_test_t';
    end;

    handles.output.params = {...
    'idx_fea', mat2str(eval(get(handles.edit_idx_fea, 'String'))), ...
    'fsg', sfsg, ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function edit_idx_fea_Callback(hObject, eventdata, handles)
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_fsg_Callback(hObject, eventdata, handles)
function popupmenu_fsg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
