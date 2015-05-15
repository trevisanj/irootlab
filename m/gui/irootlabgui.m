%>@ingroup guigroup mainguis
%> @file
%> @brief OpenSpec main GUI
%>
%> Contains shortcuts to major GUIs and allows to see auto-generated code.
%> @image html Screenshot-openspecgui.png

%> @cond
function varargout = irootlabgui(varargin)

% Edit the above text to modify the response to help openspecgui

% Last Modified by GUIDE v2.5 25-Aug-2012 23:16:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @openspecgui_OpeningFcn, ...
                   'gui_OutputFcn',  @openspecgui_OutputFcn, ...
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


% --- Executes just before openspecgui is made visible.
function openspecgui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for openspecgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

o = irdata();
set(handles.pushbuttonDatatool, 'BackgroundColor', o.color);
o = irobj();
set(handles.pushbuttonObjtool, 'BackgroundColor', o.color);


% initialization
global handles_irootlab;
ircode_assert();
set(handles.textVersion, 'string', sprintf('%s', irootlab_version));
handles_irootlab = handles;
refresh_code();
colors_markers();
gui_set_position(hObject);
setup_load();


% --- Outputs from this function are returned to the command line.
function varargout = openspecgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%##########################################################################
%##########################################################################
% Auxiliary functions

%#########
function refresh_code()
ircode_assert();
global handles_irootlab IRCODE;
set(handles_irootlab.editCode, 'String', IRCODE.s);
set(handles_irootlab.text_codefilename, 'String', ['File: ' IRCODE.filename]);


%##########################################################################
%##########################################################################


% --- Executes on button press in pushbuttonDatatool.
function pushbuttonDatatool_Callback(hObject, eventdata, handles)
datatool();

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function moAbout_Callback(hObject, eventdata, handles)
about();

% --- Executes on button press in pushbuttonObjtool.
function pushbuttonObjtool_Callback(hObject, eventdata, handles)
objtool();

function editCode_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editCode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRefreshCode.
function pushbuttonRefreshCode_Callback(hObject, eventdata, handles)
refresh_code();


% --------------------------------------------------------------------
function moExit_Callback(hObject, eventdata, handles)
delete(handles.figure1);



% --- Executes on button press in pushbuttonReset.
function pushbuttonReset_Callback(hObject, eventdata, handles)
ircode_reset();
ircode_assert();
refresh_code();


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
try
    global IRCODE;
    if ~isempty(IRCODE) && ~isempty(IRCODE.filename)
        [name, path, filterindex] = uiputfile({'*.m', 'MATLAB source file(*.m)'}, 'Save as', IRCODE.filename);
        if name > 0
            IRCODE.filename = fullfile(path, name);
            ircode_eval([], ['>>>>>>>>>>>>>>>>> Saved as ' IRCODE.filename]);
        end;
    end;
catch ME
    msgbox(ME.message, 'Error!');
end;




% --- Executes on button press in checkbox_flag_logtake.
function checkbox_flag_logtake_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton_mergetool.
function pushbutton_mergetool_Callback(hObject, eventdata, handles)
mergetool();

function Untitled_open_help_Callback(hObject, eventdata, handles)
help2();


% --- Executes on button press in pushbutton_help.
function pushbutton_help_Callback(hObject, eventdata, handles)
help2();

% --- Executes on button press in pushbutton_web.
function pushbutton_web_Callback(hObject, eventdata, handles)
web('http://irootlab.googlecode.com', '-browser');

%> @endcond


% --------------------------------------------------------------------
