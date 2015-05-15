%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_image
%> @image html Screenshot-uip_vis_image.png
%>
%> <b>Mode</b> - see vis_image::mode
%>
%> <b>Index of feature</b> - see vis_image::idx_fea
%>
%> @sa vis_image

%> @cond
function varargout = uip_vis_image(varargin)
% Last Modified by GUIDE v2.5 11-Jun-2011 02:11:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_image_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_image_OutputFcn, ...
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


% --- Executes just before uip_vis_image is made visible.
function uip_vis_image_OpeningFcn(hObject, eventdata, handles, varargin)
handles.input.block = varargin{1};
if nargin > 4
    handles.input.data = varargin{2};
else
    handles.input.data = [];
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

%#################################################################################################

%#########
function preview(handles)
data = handles.input.data;
if isempty(data)
    irerrordlg('Dataset not specified!', 'Cannot preview');
end;
o = handles.input.block;
eval(['o = o.setbatch(', params2str(get_params(handles)), ');']);
o.flag_set_position = 0;
cla(handles.axes1, 'reset');
axes(handles.axes1);
o = o.use(data);
title('');

%#########
function params = get_params(handles)

params = {...
'mode', int2str(get(handles.popupmenu_mode, 'Value')-1), ...
'idx_fea', int2str(eval(get(handles.edit_idx_fea, 'String'))) ...
};



%#################################################################################################


% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_image_OutputFcn(hObject, eventdata, handles) 
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
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_mode.
function popupmenu_mode_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_mode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_preview.
function pushbutton_preview_Callback(hObject, eventdata, handles)
preview(handles);
%> @endcond
