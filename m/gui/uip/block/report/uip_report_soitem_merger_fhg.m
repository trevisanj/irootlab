%> @ingroup guigroup
%> @file
%> @brief Properties Window for @ref report_soitem_merger_fhg
%> @image html Screenshot-uip_report_soitem_merger_fhg.png
%> @sa report_soitem_merger_fhg

%> @cond
function varargout = uip_report_soitem_merger_fhg(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_report_soitem_merger_fhg_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_report_soitem_merger_fhg_OutputFcn, ...
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


% --- Executes just before uip_report_soitem_merger_fhg is made visible.
function uip_report_soitem_merger_fhg_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);


% --- Outputs from this function are returned to the command clae.
function varargout = uip_report_soitem_merger_fhg_OutputFcn(hObject, eventdata, handles) 
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
    other = uip_report_soitem_merger_merger_fhg();
    if other.flag_ok
        handles.output.params = [other.params, {...
        'flag_draw_histograms', int2str(get(handles.checkbox_flag_draw_histograms, 'Value')) ...
        }];
        handles.output.flag_ok = 1;
        guidata(hObject, handles);
        uiresume();
    end;
catch ME
    irerrordlg(ME.message, 'Cannot continue');
end;
function checkbox_flag_draw_histograms_Callback(hObject, eventdata, handles) %#ok<*INUSD>
%> @endcond
