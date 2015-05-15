%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_soitem_merger_merger_fitest
%> @sa report_soitem_merger_merger_fitest

%>@cond
function varargout = uip_report_soitem_merger_merger_fitest(varargin)
% Last Modified by GUIDE v2.5 13-Sep-2012 21:25:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_soitem_merger_merger_fitest_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_soitem_merger_merger_fitest_OutputFcn, ...
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


% --- Executes just before uip_report_soitem_merger_merger_fitest is made visible.
function uip_report_soitem_merger_merger_fitest_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_soitem_merger_merger_fitest_OutputFcn(hObject, eventdata, handles) 
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
%############################################

function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
try
    handles.output.params = {...
    'minimum', mat2str(eval(get(handles.edit_minimum, 'String'))), ...
    'maximum', mat2str(eval(get(handles.edit_maximum, 'String'))) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;
function edit_minimum_Callback(hObject, eventdata, handles) %#ok<*INUSD>
function edit_minimum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_maximum_Callback(hObject, eventdata, handles)
function edit_maximum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
