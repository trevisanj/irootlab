%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_estlog
%>
%> <b>Generate time snapshot confusion matrices</b> - see report_estlog::flag_individual
%>
%> @sa report_estlog

%> @cond
function varargout = uip_report_estlog(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_estlog_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_estlog_OutputFcn, ...
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


% --- Executes just before uip_report_estlog is made visible.
function uip_report_estlog_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_estlog_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch %#ok<*CTCH>
    output.flag_ok = 0;
    output.params = {};
    varargout{1} = output;
end;

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*INUSL>
try
    handles.output.params = {...
    'flag_individual', int2str(get(handles.checkbox_flag_individual, 'Value')), ...
    'flag_balls', int2str(get(handles.checkbox_flag_balls, 'Value')), ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function checkbox_flag_individual_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSD>
function checkbox_flag_balls_Callback(hObject, eventdata, handles)
%> @endcond
