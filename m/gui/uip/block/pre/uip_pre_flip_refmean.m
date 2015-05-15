%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref pre_flip_refmean
%>
%> <b>Index of class to be origin</b> - see vis_cv::idx_class_origin
%>
%> @sa pre_flip_refmean

%>@cond
function varargout = uip_pre_flip_refmean(varargin)
% Last Modified by GUIDE v2.5 12-Dec-2011 19:51:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_pre_flip_refmean_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_pre_flip_refmean_OutputFcn, ...
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


% --- Executes just before uip_pre_flip_refmean is made visible.
function uip_pre_flip_refmean_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_pre_flip_refmean_OutputFcn(hObject, eventdata, handles) 
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
try
    refclass = eval(get(handles.edit_idx_refclass, 'String'));
    if refclass < 1
        irerror('Index of reference class needs to be >= 1!');
    end;

    handles.output.params = {...
    'idx_refclass', int2str(refclass) ...
    };
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function edit_idx_refclass_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit_idx_refclass_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_data_input.
function popupmenu_data_input_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_data_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
