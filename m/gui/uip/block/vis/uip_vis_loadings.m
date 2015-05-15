%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_loadings
%> @image html Screenshot-uip_vis_loadings.png
%>
%> <b>Indexes of features to plot</b> - see vis_loadings::idx_fea
%>
%> @sa vis_loadings

%>@cond
function varargout = uip_vis_loadings(varargin)
% Last Modified by GUIDE v2.5 28-Sep-2011 21:27:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_loadings_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_loadings_OutputFcn, ...
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


% --- Executes just before uip_vis_loadings is made visible.
function uip_vis_loadings_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_loadings_OutputFcn(hObject, eventdata, handles) 
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
function pushbuttonOK_Callback(hObject, eventdata, handles) %#ok<*DEFNU,*INUSL>
try
    other = uip_vis_grades();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'idx_fea', mat2str(eval(get(handles.edit_idx_hist, 'String'))) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;


function edit_idx_hist_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_hist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
