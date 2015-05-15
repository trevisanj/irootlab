%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref vis_curvefit
%> @image html Screenshot-uip_vis_curvefit.png
%>
%> <b>Index of feature</b> - see vis_curvefit::idx_fea
%>
%> <b>Class concentrations</b> - see vis_curvefit::conc
%>
%> <b>Take absolute values of scores</b> - see vis_curvefit::flag_abs
%>
%> <b>Turn figure upside down</b> - see vis_curvefit::flag_ud
%>
%> @sa vis_curvefit

%>@cond
function varargout = uip_vis_curvefit(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2011 14:18:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_vis_curvefit_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_vis_curvefit_OutputFcn, ...
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


% --- Executes just before uip_vis_curvefit is made visible.
function uip_vis_curvefit_OpeningFcn(hObject, eventdata, handles, varargin)
if nargin > 4
    handles.input.data = varargin{2};
else
    handles.input.data = [];
end;
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_vis_curvefit_OutputFcn(hObject, eventdata, handles) 
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
function params = get_params(handles)
types = {'threshold', 'ranges'};

params = {...
'idx_fea', int2str(eval(get(handles.edit_idx_fea, 'String'))), ...
'flag_abs', int2str(get(handles.checkbox_flag_abs, 'Value')), ...
'flag_ud', int2str(get(handles.checkbox_flag_ud, 'Value')), ...
'conc', mat2str(eval(fel(get(handles.edit_conc, 'String')))) ...
};


%############################################
%############################################


% --- Executes on button press in pushbuttonOk.
function pushbuttonOk_Callback(hObject, eventdata, handles)
try
    handles.output.params = get_params(handles);
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function edit_conc_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_conc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPreview.
function pushbuttonPreview_Callback(hObject, eventdata, handles)
preview(handles);

function edit_idx_fea_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_idx_fea_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_flag_abs.
function checkbox_flag_abs_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox_flag_ud.
function checkbox_flag_ud_Callback(hObject, eventdata, handles)
%> @endcond
