%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_cv
%> @image html Screenshot-uip_vis_cv.png
%>
%> <b>Input dataset</b> - see vis_cv::data_input
%>
%> <b>Index of class to be origin</b> - see vis_cv::idx_class_origin
%>
%> @sa vis_cv

%>@cond
function varargout = uip_vis_cv(varargin)
% Last Modified by GUIDE v2.5 26-Jun-2011 13:56:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_cv_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_cv_OutputFcn, ...
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


% --- Executes just before uip_vis_cv is made visible.
function uip_vis_cv_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
listbox_load_from_workspace('irdata', handles.popupmenu_data_input, 0);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_cv_OutputFcn(hObject, eventdata, handles) 
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
    sdata2 = listbox_get_selected_1stname(handles.popupmenu_data_input);
    if isempty(sdata2)
        error('Input dataset not specified!');
    end;

    other = uip_vis_grades();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'data_input', sdata2, ...
        'idx_class_origin', int2str(eval(get(handles.edit_idx_class_origin, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;


function edit_idx_class_origin_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_class_origin_CreateFcn(hObject, eventdata, handles)
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
