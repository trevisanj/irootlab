%> @ingroup guigroup
%> @file
%> @brief Properties Window for K-Fold Cross-validation (@ref sgs_crossval)
%>
%> See sgs_crossval for usage.
%>
%> @image html Screenshot-uip_sgs_crossval.png
%>
%> <b>Leave-one-out</b> - see sgs_crossval::flag_loo
%>
%> <b>K-Fold's "K"</b> - see sgs_crossval::no_reps
%>
%> @sa sgs_crossval, uip_sgs.m, sgs
%
%> @cond
function varargout = uip_sgs_crossval(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:06:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_sgs_crossval_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_sgs_crossval_OutputFcn, ...
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


% --- Executes just before uip_sgs_crossval is made visible.
function uip_sgs_crossval_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_sgs_crossval_OutputFcn(hObject, eventdata, handles) 
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

function editReg_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editReg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    other = uip_sgs();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'flag_loo', int2str(get(handles.checkbox_flag_loo, 'Value')), ...
        'no_reps', num2str(eval(get(handles.edit_no_reps, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on button press in checkbox_flag_loo.
function checkbox_flag_loo_Callback(hObject, eventdata, handles)

function edit_no_reps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_no_reps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
