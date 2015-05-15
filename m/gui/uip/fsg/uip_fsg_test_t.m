%>@file
%>@ingroup guigroup
%>@brief Properties Window for @ref fsg_test_t
%>
%> <b>Calculate as -log10(p_value)</b> - see fsg_test_t::flag_logtake
%>
%> @sa fsg_test_t

%>@cond
function varargout = uip_fsg_test_t(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_fsg_test_t_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_fsg_test_t_OutputFcn, ...
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


% --- Executes just before uip_fsg_test_t is made visible.
function uip_fsg_test_t_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);



% --- Outputs from this function are returned to the command clae.
function varargout = uip_fsg_test_t_OutputFcn(hObject, eventdata, handles) 
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
% hObject    handle to pushbuttonOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.output.params = {...
    'flag_logtake', int2str(get(handles.checkbox_flag_logtake, 'Value')) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


% --- Executes on button press in checkbox_flag_logtake.
function checkbox_flag_logtake_Callback(hObject, eventdata, handles)
%> @endcond
