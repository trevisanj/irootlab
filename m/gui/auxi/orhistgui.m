%> @ingroup guigroup
%> @file
%> @brief GUI to preview the action outlier removal.
%> @image html Screenshot-orhistgui.png
%
%> @param block A @c blmisc_rowsout_uni block.
%> @param flag_modal=0 Whether to make the window modal or not.
function varargout = orhistgui(varargin)
% Last Modified by GUIDE v2.5 11-Feb-2011 15:10:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orhistgui_OpeningFcn, ...
                   'gui_OutputFcn',  @orhistgui_OutputFcn, ...
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

%> @cond
% --- Executes just before orhistgui is made visible.
function orhistgui_OpeningFcn(hObject, eventdata, handles, varargin)
try
    
    if nargin < 4
        irverbose('INFO: Block of class blmisc_rowsout_uni not passed to orhistgui.', 1);
        blk = [];
    else
        blk = varargin{1};
    end;
    
    if nargin < 5
        handles.flag_modal = 0;
    else
        handles.flag_modal = varargin{2};
    end;
    
    if ~isempty(blk) 
        if ~isa(varargin{1}, 'blmisc_rowsout_uni')
            irerror('Block is not a blmisc_rowsout_uni!');
        end;
        if ~blk.flag_trained
            irerror('Block is not trained, needs to be trained!');
        end;
    end;

    handles.output = hObject;
    guidata(hObject, handles);
    orhistgui_set_remover(blk);
    gui_set_position(hObject);
    orhistgui_refresh();
catch ME
    send_error(ME);
end;

function pushbutton_redraw_Callback(hObject, eventdata, handles) %#ok<*INUSD,*DEFNU>
orhistgui_view1();

function pushbuttonView_Callback(hObject, eventdata, handles)
orhistgui_view2();

function pushbutton_refresh_Callback(hObject, eventdata, handles)
orhistgui_refresh();

function orhistgui_OutputFcn(hObject, eventdata, handles)  %#ok<*INUSL>
if handles.flag_modal
    set(hObject, 'WindowStyle', 'modal');
    uiwait(handles.figure1);
else
    set(hObject, 'WindowStyle', 'normal');
end;

function popupmenu_data_Callback(hObject, eventdata, handles)

function popupmenu_data_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%> @endcond
