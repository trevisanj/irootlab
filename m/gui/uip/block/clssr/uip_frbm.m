%> @ingroup guigroup
%> @file
%> @brief Properties Window for Fuzzy Rule-Based Model (@ref frbm)
%>
%> @image html Screenshot-uip_frbm.png
%>
%> <b>Multiple logical targets</b>: frbm::flag_class2mo
%>
%> <b>Scale</b>: frbm::scale
%>
%> <b>Epsilon</b>: frbm::epsilon
%>
%> <b>Use Input/output space</b>: frbm::flag_iospace
%>
%> <b>Clone closest rule radius at new rule</b>: frbm::flag_clone_rule_radii
%>
%> <b>Add Ps < Pmin to condition...</b>: frbm::flag_consider_Pmin
%>
%> <b>Rule updating function</b>: frbm::s_f_update_rules
%>
%> <b>Group rules per class</b>: frbm::flag_perclass
%>
%> <b>Firing level calculator</b>: frbm::s_f_get_firing
%>
%> <b>Takagi-Sugeno order</b>: frbm::ts_order
%>
%> <b>Defuzzification</b>: frbm::flag_wta
%>
%> <b>Global RLS</b>: frbm::flag_rls_global
%>
%> @sa frbm

%> @cond
function varargout = uip_frbm(varargin)
% Last Modified by GUIDE v2.5 19-Mar-2011 22:55:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @uip_frbm_OpeningFcn, ...
                   'gui_OutputFcn',  @uip_frbm_OutputFcn, ...
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


% --- Executes just before uip_frbm is made visible.
function uip_frbm_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output.flag_ok = 0;
guidata(hObject, handles);
gui_set_position(hObject);



% --- Outputs from this function are returned to the command line.
function varargout = uip_frbm_OutputFcn(hObject, eventdata, handles) 
try
    uiwait(handles.figure1);
    handles = guidata(hObject);
    varargout{1} = handles.output;
    delete(gcf);
catch
    output.flag_ok = 0;
    varargout{1} = output;
end;


function pushbuttonCreateFRBM_Callback(hObject, eventdata, handles)

try
%         'f_train', sprintf('@%s', fel(get(handles.popupmenuFTrain, 'String'))), ...
%         'max_rules_per_group', sprintf('%d', eval(get(handles.editMaxR, 'String'))), ...
%         's_script_support_rule', sprintf('''%s''', fel(get(handles.popupmenu_f_support_rule, 'String'), get(handles.popupmenu_f_support_rule, 'Value'))), ...
    handles.output.params = {...
        'scale', get(handles.editScale, 'String'), ...
        'epsilon', get(handles.editEpsilon, 'String'), ...
        'flag_consider_Pmin', sprintf('%d', get(handles.checkboxConPMin, 'Value') ~= 0), ...
        'flag_perclass', sprintf('%d', get(handles.checkboxPerClass, 'Value') ~= 0), ...
        'flag_clone_rule_radii', sprintf('%d', get(handles.checkboxCloneRadius, 'Value') ~= 0), ...
        'flag_iospace', sprintf('%d', get(handles.checkboxIOSpace, 'Value') ~= 0), ...
        's_f_get_firing', sprintf('''%s''', fel(get(handles.popupmenuFiring, 'String'), get(handles.popupmenuFiring, 'Value'))), ...
        's_f_update_rules', sprintf('''%s''', fel(get(handles.popupmenuFRuleUpdate, 'String'), get(handles.popupmenuFRuleUpdate, 'Value'))), ...
        'flag_rls_global', sprintf('%d', get(handles.checkbox_flag_rls_global, 'Value') ~= 0), ...
        'rho', mat2str(eval(get(handles.editRho, 'String'))), ...
        'ts_order', sprintf('%d', get(handles.popupmenuTSOrder, 'Value')-1), ...
        'flag_wta', sprintf('%d', get(handles.popupmenuDefuzzification, 'Value') ~= 1) ...
        'flag_class2mo', sprintf('%d', get(handles.checkboxFlagClass2MO, 'Value') ~= 0)...
    };
    %     'flag_b_classic', sprintf('%d', get(handles.checkboxBClassic, 'Value') ~= 0), ...
    %     'new_rule_factor', mat2str(eval(get(handles.editNewRuleFactor, 'String'))), ...
    handles.output.flag_ok = 1;
    guidata(hObject, handles);
    uiresume();
catch ME
    irerrordlg(ME.message, 'Cannot continue');
    
end;

function popupmenuFiring_Callback(hObject, eventdata, handles)

function popupmenuFiring_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkboxConPMin_Callback(hObject, eventdata, handles)

function popupmenuFRuleUpdate_Callback(hObject, eventdata, handles)

function popupmenuFRuleUpdate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editMaxR_Callback(hObject, eventdata, handles)

function editMaxR_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuFTrain_Callback(hObject, eventdata, handles)

function popupmenuFTrain_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuRuleGrouping_Callback(hObject, eventdata, handles)

function popupmenuRuleGrouping_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editScale_Callback(hObject, eventdata, handles)

function editScale_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editEpsilon_Callback(hObject, eventdata, handles)

function editEpsilon_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuTSOrder_Callback(hObject, eventdata, handles)

function popupmenuTSOrder_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editRho_Callback(hObject, eventdata, handles)

function editRho_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function checkboxIOSpace_Callback(hObject, eventdata, handles)

function checkboxPerClass_Callback(hObject, eventdata, handles)

function checkboxCloneRadius_Callback(hObject, eventdata, handles)

function popupmenuRLSOverall_Callback(hObject, eventdata, handles)

function popupmenuRLSOverall_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuDefuzzification_Callback(hObject, eventdata, handles)

function popupmenuDefuzzification_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuFDD.
function popupmenuFDD_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenuFDD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxBClassic.
function checkboxBClassic_Callback(hObject, eventdata, handles)

function editNewRuleFactor_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function editNewRuleFactor_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkboxFlagClass2MO.
function checkboxFlagClass2MO_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu_f_support_rule.
function popupmenu_f_support_rule_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_f_support_rule_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_flag_rls_global.
function checkbox_flag_rls_global_Callback(hObject, eventdata, handles)
%>@endcond
