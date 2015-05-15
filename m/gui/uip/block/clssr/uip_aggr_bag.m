%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref aggr_bag
%> @image html Screenshot-uip_aggr_bag.png
%>
%> <b>Mold classifier</b> - see aggr_bag::block_mold
%>
%> <b>SGS</b> - see aggr_bag::sgs
%>
%> @sa @ref aggr_bag, aggr, uip_aggr.m

%> @cond
function varargout = uip_aggr_bag(varargin)
% Last Modified by GUIDE v2.5 28-Aug-2011 23:27:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_aggr_bag_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_aggr_bag_OutputFcn, ...
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


% --- Executes just before uip_aggr_bag is made visible.
function uip_aggr_bag_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);
refresh(handles);

% --- Outputs from this function are returned to the command clae.
function varargout = uip_aggr_bag_OutputFcn(hObject, eventdata, handles) 
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
function refresh(handles)
listbox_load_from_workspace('sgs', handles.popupmenu_sgs, 0);
listbox_load_from_workspace({'clssr', 'block_cascade_base'}, handles.popupmenu_clssr, 0);


%############################################
%############################################

% --- Executes on button press in pushbuttonOK.
function pushbuttonOK_Callback(hObject, eventdata, handles)
try
    sclssr = listbox_get_selected_1stname(handles.popupmenu_clssr);
    if isempty(sclssr)
        sclssr = '[]';
    end;
    ssgs = listbox_get_selected_1stname(handles.popupmenu_sgs);
    if isempty(ssgs)
         ssgs = '[]';
    end;

    other = uip_aggr();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'block_mold', sclssr, ...
        'sgs', ssgs, ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

% --- Executes on selection change in popupmenu_sgs.
function popupmenu_sgs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_sgs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu_clssr.
function popupmenu_clssr_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu_clssr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%> @endcond
