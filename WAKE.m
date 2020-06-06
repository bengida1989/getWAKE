function varargout = WAKE(varargin)
% WAKE MATLAB code for WAKE.fig
%
%      WAKE GUI v1.6
%      Copyright (c) 2015-2020 by Dr. Hadar Ben-Gida, OpenPIV Group
%
%      WAKE, by itself, creates a new WAKE or raises the existing
%      singleton*.
%
%      H = WAKE returns the handle to a new WAKE or the handle to
%      the existing singleton*.
%
%      WAKE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAKE.M with the given input arguments.
%
%      WAKE('Property','Value',...) creates a new WAKE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WAKE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WAKE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WAKE

% Last Modified by GUIDE v2.5 06-Jun-2020 13:40:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WAKE_OpeningFcn, ...
                   'gui_OutputFcn',  @WAKE_OutputFcn, ...
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


% CLEAR ALL FUNCTION
function clearall()
clear all;
clc;

global MASK 
global FPS
global LIFT_method
MASK = [1 11 0.5 1]; % masking parameters for the threshold [method, hsize, sigma, radius] method = 0 (gauss); method = 1 (regular)
FPS = 10; % Frames per second for the movie
LIFT_method = 3; % default computation method for calculating the cummulative circulatory lift coefficient 


% --- Executes just before WAKE is made visible.
function WAKE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WAKE (see VARARGIN)

clearall(); % Clear all the workspace when the GUI starts

% Choose default command line output for WAKE
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WAKE wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Finding the GUI vommand:
% findall(0, 'type', 'figure', 'tag', 'figure1')

% GUI tag: figure1


% --- Outputs from this function are returned to the command line.
function varargout = WAKE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in push_load_mat_file.
function push_load_mat_file_Callback(hObject, eventdata, handles)
% hObject    handle to push_load_mat_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MAT_file

[FileName,PathName] = uigetfile('*.mat','Select the flow data .mat file'); % Let the user select the .mat file
mat_file_name = fullfile(PathName, FileName); % Getting the .mat file name

% Print the selection of the user in the Command Window
if isequal(FileName,0) 
   disp('User selected Cancel')
   return;
else
   disp(['User selected ', mat_file_name])
end

set(handles.edit_mat_directory, 'String', mat_file_name); % Display the pathname of the .mat file in the GUI

h = waitbar(50/100, 'Loading .mat file...');
mat_file_name = get(handles.edit_mat_directory, 'String'); % Getting the .mat file name
disp('Loading .mat file...');
MAT_file = load(mat_file_name); % Load the .mat file into an array
close(h);

% Closing any new windows that might be open due to .MAT file loading
NEW_Figures = findall( 0, 'Type', 'Figure' , '-not' , 'Tag' , 'figure1'); % Finding the new figures, excluding the GUI, tagged as 'figure1'
NFigures = length(NEW_Figures);
for nFigures = 1 : NFigures
  close(NEW_Figures(nFigures));
end

h = waitbar(100/100, 'Loading .mat file completed');
disp('Done!');
close(h);




function edit_laser_dt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_laser_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_laser_dt as text
%        str2double(get(hObject,'String')) returns contents of edit_laser_dt as a double


% --- Executes during object creation, after setting all properties.
function edit_laser_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_laser_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dt as text
%        str2double(get(hObject,'String')) returns contents of edit_dt as a double


% --- Executes during object creation, after setting all properties.
function edit_dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_chord_Callback(hObject, eventdata, handles)
% hObject    handle to edit_chord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_chord as text
%        str2double(get(hObject,'String')) returns contents of edit_chord as a double


% --- Executes during object creation, after setting all properties.
function edit_chord_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_chord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_b_Callback(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_b as text
%        str2double(get(hObject,'String')) returns contents of edit_b as a double


% --- Executes during object creation, after setting all properties.
function edit_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bl_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bl as text
%        str2double(get(hObject,'String')) returns contents of edit_bl as a double


% --- Executes during object creation, after setting all properties.
function edit_bl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_bw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_bw as text
%        str2double(get(hObject,'String')) returns contents of edit_bw as a double


% --- Executes during object creation, after setting all properties.
function edit_bw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_w_Callback(hObject, eventdata, handles)
% hObject    handle to edit_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_w as text
%        str2double(get(hObject,'String')) returns contents of edit_w as a double


% --- Executes during object creation, after setting all properties.
function edit_w_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Uinf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Uinf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Uinf as text
%        str2double(get(hObject,'String')) returns contents of edit_Uinf as a double


% --- Executes during object creation, after setting all properties.
function edit_Uinf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Uinf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_density_Callback(hObject, eventdata, handles)
% hObject    handle to edit_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_density as text
%        str2double(get(hObject,'String')) returns contents of edit_density as a double


% --- Executes during object creation, after setting all properties.
function edit_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_viscosity_Callback(hObject, eventdata, handles)
% hObject    handle to edit_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_viscosity as text
%        str2double(get(hObject,'String')) returns contents of edit_viscosity as a double


% --- Executes during object creation, after setting all properties.
function edit_viscosity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dp_cm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dp_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dp_cm as text
%        str2double(get(hObject,'String')) returns contents of edit_dp_cm as a double


% --- Executes during object creation, after setting all properties.
function edit_dp_cm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dp_cm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_h_cut_Callback(hObject, eventdata, handles)
% hObject    handle to edit_h_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_h_cut as text
%        str2double(get(hObject,'String')) returns contents of edit_h_cut as a double

global MAT_file
edit_h = str2double(get(hObject,'String'));
[nRows,nColumns,nTime] = size(MAT_file.uf); % Getting the NEW velocity map size

if edit_h < 0 || edit_h > (nColumns-edit_h-1)
    name = (['Please choose a correct range of horizontal cut! Should be from 1 to ', num2str(round(0.5*nColumns)-1), '...']);
    msgbox(name,  'Error','error')
end

% --- Executes during object creation, after setting all properties.
function edit_h_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_h_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ni_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ni as text
%        str2double(get(hObject,'String')) returns contents of edit_ni as a double


% --- Executes during object creation, after setting all properties.
function edit_ni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nf_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nf as text
%        str2double(get(hObject,'String')) returns contents of edit_nf as a double


% --- Executes during object creation, after setting all properties.
function edit_nf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plot_axes(handles, flag)
global chord
global Uinf
global X_c
global Y_c
global U
global V
global UF
global VF
global DUDX
global DUDY
global DVDX
global DVDY
global VORTICITY
global VORTICITY_NORM
global SWIRL
global MASK

tmp = isempty(VORTICITY); % check if vorticity is empty or not in order to display it
if tmp == 0

    if flag == 1
        cla(handles.axes1,'reset');
    end

disp_vec = get(handles.radiobutton_dispvector,'Value'); % Radio button for displaying vectors in the map
vec_space = str2double(get(handles.edit_vector_spacing, 'string')); % Getting the vec spacing in axes1
vec_size = str2double(get(handles.edit_vec_size, 'string')); % Getting the vecotr scale size
contour_max = str2double(get(handles.edit_contour_max, 'string')); % Getting the maximum contour level
contour_min = str2double(get(handles.edit_contour_min, 'string')); % Getting the minimum contour level
scale_map = get(handles.radiobutton_scale,'Value'); % Radio button for scaling map
colormap_selection = str2double(getCurrentPopupString(handles.popupmenu_colormap)); % colormap selection

vort_thresh = str2double(get(handles.edit_vort_threshold, 'string')); % Vorticity threshold
 % X fraction of the max VORTICITY_NORM will be eliminated
if vort_thresh < 0 || vort_thresh > 100
    name = ('Please choose a correct range of vorticity threshold! Should be from 1 to 100...');
    msgbox(name,  'Error','error')
    return;
end 
vort_thresh = vort_thresh/100; % precentage to ratio

thresh_criterion = getCurrentPopupString(handles.popupmenu_threshold); 
VORTICITY_NORM = (chord/Uinf).*(vorticity_threshold(VORTICITY, SWIRL, thresh_criterion, vort_thresh, MASK)); % Thresholding on the vorticity

% Plot the final wake
if flag == 1
    axes(handles.axes1); % Focusing on Figure 1   
elseif flag == 2 % open a figure
    figure(1);
end
labelsize = 18; % fontsize of the labels
fontname = 'Times New Roman'; % font name
axessize = 14; % fontsize of the axes    
x_axis1{1} = X_c; % x1 values
x_axis1{2} = '$x/c$'; % x1 label
y_axis{1} = Y_c; % y values
y_axis{2} = '$y/c$'; % y label
c_axis{1} = VORTICITY_NORM; % c values
c_axis{2} = '\omega_z\cdotc/U_\infty'; % c label
c_axis{3} = [contour_min contour_max]; % c limits
color_bar{1} = COLOR(colormap_selection)./256; % colormap
color_bar{2} = 5; % colorbar delta ticks
fonts{1} = labelsize; % labels font size
fonts{2} = fontname; % font name
fonts{3} = axessize; % axes font size
if disp_vec == 1
    q_axis{1} = UF; % quiver u velocity
    q_axis{2} = VF; % quiver v velocity
    q_axis{3} = 0.2; % quiver LineWidth
    q_axis{4} = vec_size; % quiver AutoScaleFactor
    q_axis{5} = vec_space;
    if scale_map == 1
        contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
    else 
        contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
    end
else 
    if scale_map == 1
        contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, '');
    else 
        contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, '');
    end
end
if flag == 2 % open a figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1]); % enlarging the figure to fullscreen 
    set(gcf, 'PaperType', 'B4', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
end
end



function edit_vort_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vort_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vort_threshold as text
%        str2double(get(hObject,'String')) returns contents of edit_vort_threshold as a double
% Hint: get(hObject,'Value') returns toggle state of radiobutton_dispvector
plot_axes(handles, 1)

% --- Executes during object creation, after setting all properties.
function edit_vort_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vort_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mat_directory_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mat_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mat_directory as text
%        str2double(get(hObject,'String')) returns contents of edit_mat_directory as a double


% --- Executes during object creation, after setting all properties.
function edit_mat_directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mat_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_wake_gen.
function pushbutton_wake_gen_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_wake_gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MAT_file
global chord
global Uinf
global X_c
global Y_c
global U
global V
global UF
global VF
global DUDX
global DUDY
global DVDX
global DVDY
global VORTICITY
global VORTICITY_NORM
global INPUTS 
global SWIRL 
global MASK

h = waitbar(0,'Please wait...');

cla(handles.axes1,'reset');

[nRows,nColumns,nTime] = size(MAT_file.uf); % Getting the NEW velocity map size

close(h);
h = waitbar(25/100,'Getting inputs...');

laser_dt = str2double(get(handles.edit_laser_dt, 'string')); % [sec] dt used by the laser between 2 PIV images
p_cm = str2double(get(handles.edit_dp_cm, 'string')); % [pixel/cm] pixel to cm ratio
dt = str2double(get(handles.edit_dt, 'string')); % [sec] dt between 2 velocity maps
chord = str2double(get(handles.edit_chord, 'string')); % [m] bird's chord
wingspan = str2double(get(handles.edit_b, 'string')); % [m] bird's wingspan that includes the body width
body_l = str2double(get(handles.edit_bl, 'string')); % [m] bird's body length
body_w = str2double(get(handles.edit_bw, 'string')); % [m] bird's body width
weight = str2double(get(handles.edit_w, 'string')); % [kg] bird's weight
Uinf = str2double(get(handles.edit_Uinf, 'string')); % [m/sec] Free stream velocity
density = str2double(get(handles.edit_density, 'string')); % [kg/m^3] Air density
viscosity = str2double(get(handles.edit_viscosity, 'string')); % [Pa*sec] Air viscosity
horizontal_cut = str2double(get(handles.edit_h_cut, 'string')); % Horizontal cut the user want to perform for the PIV velocity maps
vertical_cut = str2double(get(handles.edit_v_cut, 'string')); % Vertical cut the user want to perform for the PIV velocity maps
vort_thresh = str2double(get(handles.edit_vort_threshold, 'string')); % Vorticity threshold
ni = str2double(get(handles.edit_ni, 'string')); % Initial velocity map in the sequence
nf = str2double(get(handles.edit_nf, 'string')); % Final velocity map in the sequence
cross_parameter = getCurrentPopupString(handles.popupmenu_cross); % geting the paramter based on which the cross-correlation will be performed
disp_vec = get(handles.radiobutton_dispvector,'Value'); % Radio button for displaying vectors in the map
vec_space = str2double(get(handles.edit_vector_spacing, 'string')); % Getting the vec spacing in axes1
vec_size = str2double(get(handles.edit_vec_size, 'string')); % Getting the vecotr scale size
contour_max = str2double(get(handles.edit_contour_max, 'string')); % Getting the maximum contour level
contour_min = str2double(get(handles.edit_contour_min, 'string')); % Getting the minimum contour level
scale_map = get(handles.radiobutton_scale,'Value'); % Radio button for scaling map
colormap_selection = str2double(getCurrentPopupString(handles.popupmenu_colormap)); % colormap selection


close(h);
h = waitbar(50/100, 'Performing main calculation...');

if strcmp(get(handles.edit_nf, 'string'), 'end')==1
    nf = nTime; % Final velocity map in the sequence
end
if strcmp(get(handles.edit_ni, 'string'), 'start')==1
    ni = 1; % Initial velocity map in the sequence
end

if nTime<nf || ni<1 || nf<ni || strcmp(get(handles.edit_ni, 'string'), 'end')==1 || strcmp(get(handles.edit_nf, 'string'), 'start')==1 || ...
        isnan(ni)==1 || isnan(nf)==1
    name = (['Please choose a correct range of velocity maps! Should be from 1 to ', num2str(nTime), '...']);
    msgbox(name,  'Error','error')
    close(h);
else
    INPUTS = [laser_dt, p_cm, dt, chord, wingspan, body_l, body_w, weight,...
    Uinf, density, viscosity, horizontal_cut, vertical_cut,...
    ni, nf];

    % Performing the main program
    [X_c, Y_c, U, V, UF, VF, DUDX, DUDY, DVDX, DVDY, VORTICITY, SWIRL] = main(MAT_file, INPUTS, cross_parameter);
    
    close(h);
    h = waitbar(75/100, 'Displaying wake figure...');

    
    % X fraction of the max VORTICITY_NORM will be eliminated
    if vort_thresh < 0 || vort_thresh > 100
        name = ('Please choose a correct range of vorticity threshold! Should be from 1 to 100...');
        msgbox(name,  'Error','error')
        return;
    end 
    vort_thresh = vort_thresh/100; % precentage to ratio
    
    thresh_criterion = getCurrentPopupString(handles.popupmenu_threshold);
    VORTICITY_NORM = (chord/Uinf).*(vorticity_threshold(VORTICITY, SWIRL, thresh_criterion, vort_thresh, MASK)); % Thresholding on the vorticity
    
    
% Plot the final wake
axes(handles.axes1); % Focusing on Figure 1   
labelsize = 18; % fontsize of the labels
fontname = 'Times New Roman'; % font name
axessize = 14; % fontsize of the axes    
x_axis1{1} = X_c; % x1 values
x_axis1{2} = '$x/c$'; % x1 label
y_axis{1} = Y_c; % y values
y_axis{2} = '$y/c$'; % y label
c_axis{1} = VORTICITY_NORM; % c values
c_axis{2} = '\omega_z\cdotc/U_\infty'; % c label
c_axis{3} = [contour_min contour_max]; % c limits
color_bar{1} = COLOR(colormap_selection)./256; % colormap
color_bar{2} = 5; % colorbar delta ticks
fonts{1} = labelsize; % labels font size
fonts{2} = fontname; % font name
fonts{3} = axessize; % axes font size
if disp_vec == 1
    q_axis{1} = UF; % quiver u velocity
    q_axis{2} = VF; % quiver v velocity
    q_axis{3} = 0.2; % quiver LineWidth
    q_axis{4} = vec_size; % quiver AutoScaleFactor
    q_axis{5} = vec_space;
    if scale_map == 1
        contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
    else 
        contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis);
    end
else 
    if scale_map == 1
        contourxy(x_axis1, y_axis, c_axis, color_bar, fonts, '');
    else 
        contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, '');
    end
end
close(h);
h = waitbar(100/100, 'Finished!');
close(h);
end


function edit_v_cut_Callback(hObject, eventdata, handles)
% hObject    handle to edit_v_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_v_cut as text
%        str2double(get(hObject,'String')) returns contents of edit_v_cut as a double
global MAT_file
edit_v = str2double(get(hObject,'String'));
[nRows,nColumns,nTime] = size(MAT_file.uf); % Getting the NEW velocity map size

if edit_v < 0 || edit_v > (nRows-edit_v-1)
    name = (['Please choose a correct range of vertical cut! Should be from 1 to ', num2str(round(0.5*nRows)-1), '...']);
    msgbox(name,  'Error','error')
end

% --- Executes during object creation, after setting all properties.
function edit_v_cut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_v_cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_cross.
function popupmenu_cross_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_cross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_cross contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_cross


% --- Executes during object creation, after setting all properties.
function popupmenu_cross_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_cross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% Get the current popup string chosen by the user
function str = getCurrentPopupString(hh)
% returns the currently selected string in the popupmenu with handle hh

% Test input
if ~ishandle(hh) || strcmp(get(hh,'Type'),'popupmenu')
error('getCurrentPopupString needs a handle to a popupmenu as input')
end

% get the string
list = get(hh,'String'); % getting the list of items in the popup menu
val = get(hh,'Value'); % getting the current value
if iscell(list)
   str = list{val}; % Finding the current string chosen by the user
else
   str = list(val,:);
end




function edit_vector_spacing_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vector_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vector_spacing as text
%        str2double(get(hObject,'String')) returns contents of edit_vector_spacing as a double
plot_axes(handles, 1)



% --- Executes during object creation, after setting all properties.
function edit_vector_spacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vector_spacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_vec_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vec_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vec_size as text
%        str2double(get(hObject,'String')) returns contents of edit_vec_size as a double
plot_axes(handles, 1)


% --- Executes during object creation, after setting all properties.
function edit_vec_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vec_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_dispvector.
function radiobutton_dispvector_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_dispvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_dispvector
plot_axes(handles, 1)



function edit_contour_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_contour_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_contour_max as text
%        str2double(get(hObject,'String')) returns contents of edit_contour_max as a double
plot_axes(handles, 1)


% --- Executes during object creation, after setting all properties.
function edit_contour_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_contour_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_contour_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_contour_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_contour_min as text
%        str2double(get(hObject,'String')) returns contents of edit_contour_min as a double
plot_axes(handles, 1)


% --- Executes during object creation, after setting all properties.
function edit_contour_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_contour_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in radiobutton_scale.
function radiobutton_scale_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_scale
plot_axes(handles, 1)


% --------------------------------------------------------------------
function Inputs_Callback(hObject, eventdata, handles)
% hObject    handle to Inputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_inputs_Callback(hObject, eventdata, handles)
% hObject    handle to save_inputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% getting inputs
laser_dt = str2double(get(handles.edit_laser_dt, 'string')); % [sec] dt used by the laser between 2 PIV images
p_cm = str2double(get(handles.edit_dp_cm, 'string')); % [pixel/cm] pixel to cm ratio
dt = str2double(get(handles.edit_dt, 'string')); % [sec] dt between 2 velocity maps
chord = str2double(get(handles.edit_chord, 'string')); % [m] bird's chord
wingspan = str2double(get(handles.edit_b, 'string')); % [m] bird's wingspan that includes the body width
body_l = str2double(get(handles.edit_bl, 'string')); % [m] bird's body length
body_w = str2double(get(handles.edit_bw, 'string')); % [m] bird's body width
weight = str2double(get(handles.edit_w, 'string')); % [kg] bird's weight
Uinf = str2double(get(handles.edit_Uinf, 'string')); % [m/sec] Free stream velocity
density = str2double(get(handles.edit_density, 'string')); % [kg/m^3] Air density
viscosity = str2double(get(handles.edit_viscosity, 'string')); % [Pa*sec] Air viscosity

% Defining .mat file with all the inputs
INPUTS = [];
INPUTS.laser_dt = laser_dt;
INPUTS.p_cm = p_cm;
INPUTS.dt = dt;
INPUTS.chord = chord;
INPUTS.wingspan = wingspan;
INPUTS.body_l = body_l;
INPUTS.body_w = body_w;
INPUTS.weight = weight;
INPUTS.Uinf = Uinf;
INPUTS.density = density;
INPUTS.viscosity = viscosity;


[filename, pathname, filterindex] = uiputfile({'*.mat','MAT-files (*.mat)'}, 'Save inputs as');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
end

path = fullfile(pathname, filename); % Concentrate the two strings to one path

save(path,'INPUTS');


% --------------------------------------------------------------------
function load_inputs_Callback(hObject, eventdata, handles)
% hObject    handle to load_inputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName] = uigetfile('*.mat','Select the inputs .mat file'); % Let the user select the .mat file
mat_file_name = fullfile(PathName, FileName); % Getting the .mat file name

% Print the selection of the user in the Command Window
if isequal(FileName,0) 
   disp('User selected Cancel')
   return;
else
   disp(['User selected ', mat_file_name])
end

load(mat_file_name); % Load the INPUTS .mat file into an array

set(handles.edit_laser_dt, 'string', num2str(INPUTS.laser_dt)); % [sec] dt used by the laser between 2 PIV images
set(handles.edit_dp_cm, 'string', num2str(INPUTS.p_cm)); % [pixel/cm] pixel to cm ratio
set(handles.edit_dt, 'string', num2str(INPUTS.dt)); % [sec] dt between 2 velocity maps
set(handles.edit_chord, 'string', num2str(INPUTS.chord)); % [m] bird's chord
set(handles.edit_b, 'string', num2str(INPUTS.wingspan)); % [m] bird's wingspan that includes the body width
set(handles.edit_bl, 'string', num2str(INPUTS.body_l)); % [m] bird's body length
set(handles.edit_bw, 'string', num2str(INPUTS.body_w)); % [m] bird's body width
set(handles.edit_w, 'string', num2str(INPUTS.weight)); % [kg] bird's weight
set(handles.edit_Uinf, 'string', num2str(INPUTS.Uinf)); % [m/sec] Free stream velocity
set(handles.edit_density, 'string', num2str(INPUTS.density)); % [kg/m^3] Air density
set(handles.edit_viscosity, 'string', num2str(INPUTS.viscosity)); % [Pa*sec] Air viscosity


% --------------------------------------------------------------------
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_figure_Callback(hObject, eventdata, handles)
% hObject    handle to open_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_axes(handles, 2)


% --------------------------------------------------------------------
function save_plot_Callback(hObject, eventdata, handles)
% hObject    handle to save_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname, filterindex] = uiputfile( ...
       {'*.tiff','TIFF File (*.tiff)'; '*.jpg','JPEG File (*.jpg)';...
       '*.pdf','PDF File (*.pdf)'; '*.png','PNG File (*.png)';...
       '*.fig','Figures (*.fig)'; '*.tiff;*.jpg;*.pdf;*.png;*.fig',...
       'All MATLAB Files (*.tiff, *.jpg, *.pdf, *.png, *.fig)';...
       '*.*',  'All Files (*.*)'}, 'Save as');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
end

path = fullfile(pathname, filename); % Concentrate the two strings to one path

plot_axes(handles, 2);

fig1 = figure(1);
h = waitbar(50/100, 'Saving figure. Please wait!');
if filterindex == 1 % if the user want to save a tiff image
    print(fig1, path, '-dtiff', '-r600');
elseif filterindex == 2 % if the user want to save a jpeg image
    print(fig1, path, '-djpeg', '-r600');
elseif filterindex == 3 % if the user want to save a tiff image
    set(fig1, 'PaperType', 'B4', 'PaperOrientation', 'landscape', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
    print(fig1, path, '-dpdf', '-r600');
elseif filterindex == 4 % if the user want to save a png image
    print(fig1, path, '-dpng', '-r600');
else
    saveas(fig1, path); % saving the image according to the specified format by the user
end
close(h);
h = waitbar(100/100, 'Figure Saved!');
close(h);

close(figure(1)); % closing the new figure


% --------------------------------------------------------------------
function threshold_Callback(hObject, eventdata, handles)
% hObject    handle to threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MASK

h = figure('name', 'Threshold Properties', 'NumberTitle','off');
set(h, 'resize', 'off');
h.Units = 'normalized';
set(h, 'MenuBar','none','position', [0.5 0.5 0.185 0.3]); % set the window size and location

% generating the different objects
hp = uipanel('Position',[0 0 1 1]); % 

masking_menu = uicontrol('Parent',hp,'Style','popupmenu', 'tag', 'masking_menu', 'String',{'Gaussian Masking', 'Regular Masking'},...
    'FontSize',10, 'units', 'normalized', 'Position',[0.25 0.8 0.5 0.15]);

hsize_text = uicontrol('Parent',hp,'Style','text','String','Gaussian hsize','FontSize',10, 'units', 'normalized', 'Position',[0.05 0.6 0.36 0.12]);
hsize_edit = uicontrol('Parent',hp,'Style','edit','tag', 'hsize_edit', 'FontSize',10, 'units', 'normalized', 'Position',[0.65 0.61 0.2 0.12]);

sigma_text = uicontrol('Parent',hp,'Style','text','String','Gaussian sigma (std)','FontSize',10, 'units', 'normalized', 'Position',[0.05 0.41 0.47 0.12]);
sigma_edit = uicontrol('Parent',hp,'Style','edit', 'tag', 'sigma_edit','FontSize',10, 'units', 'normalized', 'Position',[0.65 0.42 0.2 0.12]);

disk_text = uicontrol('Parent',hp,'Style','text','String','Mask disk radius (integer)','FontSize',10, 'units', 'normalized', 'Position',[0.05 0.215 0.57 0.12]);
disk_edit = uicontrol('Parent',hp,'Style','edit', 'tag', 'disk_edit', 'String','1','FontSize',10, 'units', 'normalized', 'Position',[0.65 0.23 0.2 0.12]);

% setting the current mask used
if MASK(1) == 0
    set(masking_menu, 'string', {'Gaussian Masking', 'Regular Masking'});
elseif MASK(1) == 1
    set(masking_menu, 'string', {'Regular Masking', 'Gaussian Masking'});
end
set(hsize_edit, 'String', num2str(MASK(2)));
set(sigma_edit, 'String', num2str(MASK(3)));
set(disk_edit, 'String', num2str(MASK(4)));


handlesArray.masking_menu = masking_menu;
handlesArray.hsize_edit = hsize_edit;
handlesArray.sigma_edit = sigma_edit;
handlesArray.disk_edit = disk_edit;



OK_button = uicontrol('Parent',hp,'Style','pushbutton','String','OK',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.3 0.03 0.4 0.13], ...
    'Callback',{@ok_button_threshold, handlesArray, h});


function ok_button_threshold(hObject, callbackdata, handlesArray, h)
global MASK

tmp = getCurrentPopupString(handlesArray.masking_menu);
if strcmp(tmp, 'Gaussian Masking') == 1
    MASK(1) = 0;
elseif strcmp(tmp, 'Regular Masking') == 1
    MASK(1) = 1;
end
MASK(2) = str2double(get(handlesArray.hsize_edit, 'string'));
MASK(3) = str2double(get(handlesArray.sigma_edit, 'string'));
MASK(4) = str2double(get(handlesArray.disk_edit, 'string'));

close(h);

        
% --------------------------------------------------------------------
function Movie_Callback(hObject, eventdata, handles)
% hObject    handle to Movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_movie_Callback(hObject, eventdata, handles)
% hObject    handle to save_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MAT_file
global INPUTS
global FPS
global MASK

vort_thresh = str2double(get(handles.edit_vort_threshold, 'string')); % Vorticity threshold
disp_vec = get(handles.radiobutton_dispvector,'Value'); % Radio button for displaying vectors in the map
vec_space = str2double(get(handles.edit_vector_spacing, 'string')); % Getting the vec spacing in axes1
vec_size = str2double(get(handles.edit_vec_size, 'string')); % Getting the vecotr scale size
contour_max = str2double(get(handles.edit_contour_max, 'string')); % Getting the maximum contour level
contour_min = str2double(get(handles.edit_contour_min, 'string')); % Getting the minimum contour level
scale_map = get(handles.radiobutton_scale,'Value'); % Radio button for scaling map
colormap_selection = str2double(getCurrentPopupString(handles.popupmenu_colormap)); % colormap selection


 % X fraction of the max VORTICITY_NORM will be eliminated
if vort_thresh < 0 || vort_thresh > 100
    name = ('Please choose a correct range of vorticity threshold! Should be from 1 to 100...');
    msgbox(name,  'Error','error')
    return;
end 
vort_thresh = vort_thresh/100; % precentage to ratio



[filename, pathname, filterindex] = uiputfile( ...
       {'*.avi','Avi File (*.avi)'}, 'Save as');
if pathname == 0 %if the user pressed cancelled, then we exit this callback
    return
end

path = fullfile(pathname, filename); % Concentrate the two strings to one path

disp('Saving movie...');

thresh_criterion = getCurrentPopupString(handles.popupmenu_threshold);

movie_maker(MAT_file, INPUTS, path, FPS, vort_thresh, thresh_criterion, MASK, disp_vec,...
    vec_space, vec_size, contour_min, contour_max, scale_map, colormap_selection);
disp('Done!');


% --------------------------------------------------------------------
function save_voticity_array_Callback(hObject, eventdata, handles)
% hObject    handle to save_voticity_array (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global VORTICITY

tmp = isempty(VORTICITY); % check if vorticity is empty or not in order to display it
if tmp == 0
    
    [filename, pathname, filterindex] = uiputfile({'*.mat','MAT-files (*.mat)'}, 'Save wake vorticity as');
    if pathname == 0 %if the user pressed cancelled, then we exit this callback
        return
    end

    path = fullfile(pathname, filename); % Concentrate the two strings to one path
    
    save(path,'VORTICITY');
end


% --------------------------------------------------------------------
function movie_prop_Callback(hObject, eventdata, handles)
% hObject    handle to movie_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global FPS

h = figure('name', 'Movie Properties', 'NumberTitle','off');
set(h, 'resize', 'off');
h.Units = 'normalized';
set(h, 'MenuBar','none','position', [0.5 0.5 0.185 0.1]); % set the window size and location

% generating the different objects
hp = uipanel('Position',[0 0 1 1]); % 

fps_text = uicontrol('Parent',hp,'Style','text','String','Frames per second','FontSize',10, 'units', 'normalized', 'Position',[0.2 0.50 0.35 0.34]);
fps_edit = uicontrol('Parent',hp,'Style','edit','tag', 'fps_edit', 'FontSize',10, 'units', 'normalized', 'Position',[0.6 0.55 0.2 0.3]);

% setting the current mask used

set(fps_edit, 'String', num2str(FPS));

OK_button = uicontrol('Parent',hp,'Style','pushbutton','String','OK',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.3 0.03 0.4 0.35], ...
    'Callback',{@ok_button_fps, fps_edit, h});


function ok_button_fps(hObject, callbackdata, fps_edit, h)
global FPS

FPS = str2double(get(fps_edit, 'string'));
close(h);


% --- Executes on selection change in popupmenu_threshold.
function popupmenu_threshold_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_threshold contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_threshold
plot_axes(handles, 1)


% --- Executes during object creation, after setting all properties.
function popupmenu_threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_dsus.
function radiobutton_dsus_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_dsus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_dsus
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;

state_dsus = get(hObject,'Value');
state_usds = get(handles.radiobutton_usds,'Value');

if state_dsus == 1 && state_usds == 1
    set(handles.radiobutton_usds,'Value', 0);
elseif state_dsus == 0 && state_usds == 0    
    set(handles.radiobutton_usds,'Value', 1);
end


% Check the kinematics database is ok with the change of usds to dsus
if state_dsus == 1 && isempty(DOWNSTROKE)==0 
    first_column = DOWNSTROKE;
    second_column = TRANSITION;
    third_column = UPSTROKE;

    %% LOCGIC TESTS FOR THE TABLE INPUTS
    for i=1:length(first_column)
        if second_column(i) <= first_column(i) && second_column(i)>0 && first_column(i)>0
            name = (['Changing USDS to DSUS changed the kinematics database in a non-logic order! Please resolve the first and second columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif third_column(i) <= second_column(i) && second_column(i)>0 && third_column(i)>0
            name = (['Changing USDS to DSUS changed the kinematics database in a non-logic order! Please resolve the second and third columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif third_column(i) <= first_column(i) && first_column(i)>0 && third_column(i)>0
            name = (['Changing USDS to DSUS changed the kinematics database in a non-logic order! Please resolve the first and third columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif i>1 && first_column(i) < third_column(i-1) && third_column(i)>=0 && first_column(i)>=0
            name = (['Changing USDS to DSUS changed the kinematics database in a non-logic order! Please resolve the first column of wingbeat no. ', num2str(i), ' and the third column of wingbeat no. ' , num2str(i-1), '!']);
            msgbox(name,  'Error','error');
            break;
        end 
    end

end
    
    

% --- Executes on button press in radiobutton_usds.
function radiobutton_usds_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_usds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_usds
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;

state_dsus = get(hObject,'Value');
state_usds = get(handles.radiobutton_usds,'Value');

if state_dsus == 1 && state_usds == 1
    set(handles.radiobutton_dsus,'Value', 0);
elseif state_dsus == 0 && state_usds == 0    
    set(handles.radiobutton_dsus,'Value', 1);
end

% Check the kinematics database is ok with the change of dsus to usds
if state_usds == 1 && isempty(DOWNSTROKE)==0 
    first_column = UPSTROKE;
    second_column = TRANSITION;
    third_column = DOWNSTROKE;

    %% LOCGIC TESTS FOR THE TABLE INPUTS
    for i=1:length(first_column)
        if second_column(i) <= first_column(i) && second_column(i)>0 && first_column(i)>0
            name = (['Changing DSUS to USDS changed the kinematics database in a non-logic order! Please resolve the first and second columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif third_column(i) <= second_column(i) && second_column(i)>0 && third_column(i)>0
            name = (['Changing DSUS to USDS changed the kinematics database in a non-logic order! Please resolve the second and third columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif third_column(i) <= first_column(i) && first_column(i)>0 && third_column(i)>0
            name = (['Changing DSUS to USDS changed the kinematics database in a non-logic order! Please resolve the first and third columns of wingbeat no. ' , num2str(i), '!']);
            msgbox(name,  'Error','error');
            break;
        elseif i>1 && first_column(i) < third_column(i-1) && third_column(i)>=0 && first_column(i)>=0
            name = (['Changing DSUS to USDS changed the kinematics database in a non-logic order! Please resolve the first column of wingbeat no. ', num2str(i), ' and the third column of wingbeat no. ' , num2str(i-1), '!']);
            msgbox(name,  'Error','error');
            break;
        end
    end

end



% --------------------------------------------------------------------
function Forces_Callback(hObject, eventdata, handles)
% hObject    handle to Forces (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function plot_drag_Callback(hObject, eventdata, handles)
% hObject    handle to plot_drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global MAT_file;

% close figure(1) if it's exist
if ishandle(1)==1
    close(figure(1));
end

if isempty(MAT_file)==1
    name = ('Please load a .mat file first!');
    msgbox(name,  'Error','error');
else
    if isempty(DOWNSTROKE)==1
        name = ('Please enter kinematic database before calculating drag!');
        msgbox(name, 'Error','error');
    else
        [x_c, time, Cd_steady, Cd_unsteady] = calc_drag(handles); % Calculating the drag
        max_time = max(time);

        No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
        x_axis = getCurrentPopupString(handles.popupmenu_x_axis); % x axis chosen by the user
        x_c_gap = str2double(get(handles.edit_x_c_gap, 'string')); % Gap for the first wingbeat in x/c length
        Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from

        h = waitbar(100/100, 'Drag plot finished!');
        close (h);

        usds = get(handles.radiobutton_usds, 'Value');
        dsus = get(handles.radiobutton_dsus, 'Value');

        % Plotting the drag variation with time
        figure(1);
        ax1 = axes;
        labelsize = 16; % fontsize of the labels
        fontname = 'Times New Roman'; % font name
        axessize = 14; % fontsize of the axes  
        legendsize = 14; % fontsize of the legend

        switch x_axis
            case 'x_c'
            moving_avg = 5;
            h1(1) = plot(x_c+x_c_gap, smooth(Cd_steady, moving_avg), 'color', 'b', 'DisplayName',...
                '$C_{d_0}$', 'marker', 'x', 'markersize', 6, 'linewidth', 1.8,...
                'linestyle', 'none'); hold on;
            h1(2) = plot(x_c+x_c_gap, smooth(Cd_unsteady, moving_avg), 'color', 'r', 'DisplayName',...
                '$C_{d_1}$', 'marker', 'o', 'markersize', 6, 'linewidth', 1.8,...
                'linestyle', 'none'); hold on;
            h1(3) = plot(x_c+x_c_gap, smooth(Cd_steady + Cd_unsteady, moving_avg), 'color', 'k', 'DisplayName',...
                '$C_{d_0}+C_{d_1}$', 'linewidth', 2.2); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$x/c$', 'interpreter', 'latex', 'fontsize', labelsize);   

            case 't_T'
            moving_avg = 5;
            h1(1) = plot(time./max_time, smooth(Cd_steady, moving_avg), 'color', 'b', 'DisplayName',...
                '$C_{d_0}$', 'marker', 'x', 'markersize', 6, 'linewidth', 1.8,...
                'linestyle', 'none'); hold on;
            h1(2) = plot(time./max_time, smooth(Cd_unsteady, moving_avg), 'color', 'r', 'DisplayName',...
                '$C_{d_1}$', 'marker', 'o', 'markersize', 6, 'linewidth', 1.8,...
                'linestyle', 'none'); hold on;
            h1(3) = plot(time./max_time, smooth(Cd_steady + Cd_unsteady, moving_avg), 'color', 'k', 'DisplayName',...
                '$C_{d_0}+C_{d_1}$', 'linewidth', 2.2); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$t/T$', 'interpreter', 'latex', 'fontsize', labelsize);
        end

        ylabel(ax1, '$C_d$', 'interpreter', 'latex', 'fontsize', labelsize,...
            'rotation', 0, 'horizontalAlignment', 'right', 'verticalAlignment', 'middle');
        set(ax1, 'box', 'off');

        % get the limits of the y axis
        y_lim = get(gca, 'ylim');

        % Get the x value of the different phases
        down = zeros(1, No_wingbeats);
        up = zeros(1, No_wingbeats);
        trans = zeros(1, No_wingbeats);
        for i=Start_wingbeat:No_wingbeats
            if dsus>usds
                x_axis_h1 = h1(1).XData;
                down_ind= DOWNSTROKE(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                down(i) = x_axis_h1(down_ind); % value of the x axis for the start of the downstroke phase
                trans_ind = TRANSITION(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the upstroke phase
                up_ind = UPSTROKE(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                up(i) = x_axis_h1(up_ind); % value of the x axis for the end of the upstroke phase
            elseif usds>dsus
                x_axis_h1 = h1(1).XData;
                down_ind = DOWNSTROKE(i) - UPSTROKE(Start_wingbeat) + 1; % index of the end of the downstroke phase 
                down(i) = x_axis_h1(down_ind); % value of the x axis for the end of the downstroke phase 
                trans_ind = TRANSITION(i) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase
                trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the downstroke phase
                up_ind = UPSTROKE(i) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                up(i) = x_axis_h1(up_ind); % value of the x axis for the start of the upstroke phase
            end
        end
        
        % set x limits
        x_max = max(x_axis_h1);
        x_min = min(x_axis_h1);
        set(gca, 'xlim', [x_min x_max]);                 

        % Paint in gray the upstroke phase
        for i=Start_wingbeat:No_wingbeats
            if dsus>usds % Painting in gray the upstroke phase
                h2(1) = area([trans(i) up(i)],[y_lim(1) y_lim(1)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                h2(2) = area([trans(i) up(i)],[y_lim(2) y_lim(2)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            elseif usds>dsus % Painting in gray the upstroke phase
                h2(1) = area([up(i) trans(i)],[y_lim(1) y_lim(1)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                h2(2) = area([up(i) trans(i)],[y_lim(2) y_lim(2)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            end
        end   

        % Plot a line on y=0
        h2(3) = plot([x_axis_h1(1) x_axis_h1(end)], [0 0], '--','color',[.5 .5 .5], 'linewidth', 2); hold on;
        
        IL = legend(h1, '$C_{d_0}$', '$C_{d_1}$', '$C_{d_0}+C_{d_1}$');
        set(IL, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', legendsize, 'box', 'off');
        
        uistack(h1(1), 'top');
        uistack(h1(2), 'top');
        uistack(h1(3), 'top');
        set(ax1, 'layer', 'top');

    %     if dsus == 1
    %         text((trans+1)/2 - 0.11, -0.15, 'upstroke', 'fontsize', labelsize, 'fontname', fontname);
    %         text((0 + trans)/2 - 0.15, -0.15, 'downstroke', 'fontsize', labelsize, 'fontname', fontname);
    %     elseif usds == 1
    %         text((trans+1)/2 - 0.15, -0.15, 'downstroke', 'fontsize', labelsize, 'fontname', fontname);
    %         text((0 + trans)/2 - 0.11, -0.15, 'upstroke', 'fontsize', labelsize, 'fontname', fontname);
    %     end

    end
    
end


% --------------------------------------------------------------------
function save_drag_Callback(hObject, eventdata, handles)
% hObject    handle to save_drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global MAT_file;

% close figure(1) if it's exist
if ishandle(1)==1
    close(figure(1));
end

if isempty(MAT_file)==1
    name = ('Please load a .mat file first!');
    msgbox(name,  'Error','error');
else
    if isempty(DOWNSTROKE)==1
        name = ('Please enter kinematic database before calculating drag!');
        msgbox(name, 'Error','error');
    else
        [filename, pathname, filterindex] = uiputfile( ...
               {'*.tiff','TIFF File (*.tiff)'; '*.jpg','JPEG File (*.jpg)';...
               '*.pdf','PDF File (*.pdf)'; '*.png','PNG File (*.png)';...
               '*.fig','Figures (*.fig)'; '*.tiff;*.jpg;*.pdf;*.png;*.fig',...
               'All MATLAB Files (*.tiff, *.jpg, *.pdf, *.png, *.fig)';...
               '*.*',  'All Files (*.*)'}, 'Save as');
        if pathname == 0 %if the user pressed cancelled, then we exit this callback
            return
        end

        path = fullfile(pathname, filename); % Concentrate the two strings to one path

        [x_c, time, Cd_steady, Cd_unsteady] = calc_drag(handles);
        h = waitbar(65/100, 'Saving figure. Please wait!');
        max_time = max(time);
        
        No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
        x_axis = getCurrentPopupString(handles.popupmenu_x_axis); % x axis chosen by the user
        x_c_gap = str2double(get(handles.edit_x_c_gap, 'string')); % Gap for the first wingbeat in x/c length
        Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from

        usds = get(handles.radiobutton_usds, 'Value');
        dsus = get(handles.radiobutton_dsus, 'Value');

        
        % Plotting the drag variation with time
        fig1 = figure(1);
        ax1 = axes;
        labelsize = 38; % fontsize of the labels
        fontname = 'Times New Roman'; % font name
        axessize = 25; % fontsize of the axes  
        legendsize = 30; % fontsize of the legend

        switch x_axis
            case 'x_c'
            moving_avg = 5;
            h1(1) = plot(x_c+x_c_gap, smooth(Cd_steady, moving_avg), 'color', 'b', 'DisplayName',...
                '$C_{d_0}$', 'marker', 'x', 'markersize', 10, 'linewidth', 2.2,...
                'linestyle', 'none'); hold on;
            h1(2) = plot(x_c+x_c_gap, smooth(Cd_unsteady, moving_avg), 'color', 'r', 'DisplayName',...
                '$C_{d_1}$', 'marker', 'o', 'markersize', 10, 'linewidth', 2.2,...
                'linestyle', 'none'); hold on;
            h1(3) = plot(x_c+x_c_gap, smooth(Cd_steady + Cd_unsteady, moving_avg), 'color', 'k', 'DisplayName',...
                '$C_{d_0}+C_{d_1}$', 'linewidth', 3); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$x/c$', 'interpreter', 'latex', 'fontsize', labelsize);   

            case 't_T'
            moving_avg = 5;
            h1(1) = plot(time./max_time, smooth(Cd_steady, moving_avg), 'color', 'b', 'DisplayName',...
                '$C_{d_0}$', 'marker', 'x', 'markersize', 10, 'linewidth', 2.2,...
                'linestyle', 'none'); hold on;
            h1(2) = plot(time./max_time, smooth(Cd_unsteady, moving_avg), 'color', 'r', 'DisplayName',...
                '$C_{d_1}$', 'marker', 'o', 'markersize', 10, 'linewidth', 2.2,...
                'linestyle', 'none'); hold on;
            h1(3) = plot(time./max_time, smooth(Cd_steady + Cd_unsteady, moving_avg), 'color', 'k', 'DisplayName',...
                '$C_{d_0}+C_{d_1}$', 'linewidth', 3); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$t/T$', 'interpreter', 'latex', 'fontsize', labelsize);
        end

        ylabel(ax1, '$C_d$', 'interpreter', 'latex', 'fontsize', labelsize,...
            'rotation', 0, 'horizontalAlignment', 'right', 'verticalAlignment', 'middle');
        set(ax1, 'box', 'off');

        set(fig1,'units','normalized','outerposition',[0 0 1 1]); % enlarging the figure to fullscreen 
        set(fig1, 'PaperType', 'B4', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
        
        % get the limits of the y axis
        y_lim = get(gca, 'ylim');
        
        % Get the x value of the different phases
        down = zeros(1, No_wingbeats);
        up = zeros(1, No_wingbeats);
        trans = zeros(1, No_wingbeats);
        for i=Start_wingbeat:No_wingbeats
            if dsus>usds
                x_axis_h1 = h1(1).XData;
                down_ind= DOWNSTROKE(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                down(i) = x_axis_h1(down_ind); % value of the x axis for the start of the downstroke phase
                trans_ind = TRANSITION(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the upstroke phase
                up_ind = UPSTROKE(i) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                up(i) = x_axis_h1(up_ind); % value of the x axis for the end of the upstroke phase
            elseif usds>dsus
                x_axis_h1 = h1(1).XData;
                down_ind = DOWNSTROKE(i) - UPSTROKE(Start_wingbeat) + 1; % index of the end of the downstroke phase 
                down(i) = x_axis_h1(down_ind); % value of the x axis for the end of the downstroke phase 
                trans_ind = TRANSITION(i) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase
                trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the downstroke phase
                up_ind = UPSTROKE(i) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                up(i) = x_axis_h1(up_ind); % value of the x axis for the start of the upstroke phase
            end
        end
       
        % set x limits
        x_max = max(x_axis_h1);
        x_min = min(x_axis_h1);
        set(gca, 'xlim', [x_min x_max]);               
        % Paint in gray the upstroke phase
        for i=Start_wingbeat:No_wingbeats
            if dsus>usds % Painting in gray the upstroke phase
                h2(1) = area([trans(i) up(i)],[y_lim(1) y_lim(1)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                h2(2) = area([trans(i) up(i)],[y_lim(2) y_lim(2)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            elseif usds>dsus % Painting in gray the upstroke phase
                h2(1) = area([up(i) trans(i)],[y_lim(1) y_lim(1)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                h2(2) = area([up(i) trans(i)],[y_lim(2) y_lim(2)]*0.995,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            end
        end   

        % Plot a line on y=0
        h2(3) = plot([x_axis_h1(1) x_axis_h1(end)], [0 0], '--','color',[.5 .5 .5], 'linewidth', 2); hold on;
        IL = legend(h1, '$C_{d_0}$', '$C_{d_1}$', '$C_{d_0}+C_{d_1}$');
        set(IL, 'Interpreter', 'latex', 'Location', 'best', 'FontSize', legendsize, 'box', 'off');
        
        uistack(h1(1), 'top');
        uistack(h1(2), 'top');
        uistack(h1(3), 'top');
        set(ax1, 'layer', 'top');
%         if dsus == 1
%             text((trans+1)/2 - 0.06, -0.15, 'upstroke', 'fontsize', legendsize, 'fontname', fontname);
%             text((0 + trans)/2 - 0.08, -0.15, 'downstroke', 'fontsize', legendsize, 'fontname', fontname);
%         elseif usds == 1
%             text((trans+1)/2 - 0.08, -0.15, 'downstroke', 'fontsize', legendsize, 'fontname', fontname);
%             text((0 + trans)/2 - 0.06, -0.15, 'upstroke', 'fontsize', legendsize, 'fontname', fontname);
%         end
        
        close (h);
        h = waitbar(85/100, 'Saving figure. Please wait!');
        if filterindex == 1 % if the user want to save a tiff image
            print(fig1, path, '-dtiff', '-r600');
        elseif filterindex == 2 % if the user want to save a jpeg image
            print(fig1, path, '-djpeg', '-r600');
        elseif filterindex == 3 % if the user want to save a tiff image
            set(fig1, 'PaperType', 'B4', 'PaperOrientation', 'landscape', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
            print(fig1, path, '-dpdf', '-r600');
        elseif filterindex == 4 % if the user want to save a png image
            print(fig1, path, '-dpng', '-r600');
        else
            saveas(fig1, path); % saving the image according to the specified format by the user
        end
        close(h);
        h = waitbar(100/100, 'Figure Saved!');
        close(h);

        close(fig1); % closing the new figure
    end
end



function [x_c, time, Cd_steady, Cd_unsteady] = calc_drag(handles)
global MAT_file
global DOWNSTROKE;
global UPSTROKE;
global Uinf
global chord

h = waitbar(50/100, 'Plotting drag Please wait!');
[~, ~, nTime] = size(MAT_file.uf); % Getting the NEW velocity map size

No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
usds = get(handles.radiobutton_usds, 'Value');
dsus = get(handles.radiobutton_dsus, 'Value');
Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from

if dsus>usds
    Wingbeats_start = DOWNSTROKE(Start_wingbeat);
    Wingbeats_end = UPSTROKE(No_wingbeats);
elseif usds>dsus
    Wingbeats_start = UPSTROKE(Start_wingbeat);
    Wingbeats_end = DOWNSTROKE(No_wingbeats);
end

if Wingbeats_end > nTime - 1 || Wingbeats_start < 2
    name = (['Please choose a legit range for the wingbeat cycle! Should be from 2 to ', num2str(nTime-1), '...']);
    msgbox(name,  'Error','error')
else
    p_cm = str2double(get(handles.edit_dp_cm, 'string')); % [pixel/cm] pixel to cm ratio
    dt = str2double(get(handles.edit_dt, 'string')); % [sec] dt between 2 velocity maps
    chord = str2double(get(handles.edit_chord, 'string')); % [m] bird's chord
    Uinf = str2double(get(handles.edit_Uinf, 'string')); % [m/sec] Free stream velocity
    density = str2double(get(handles.edit_density, 'string')); % [kg/m^3] Air density
    laser_dt = str2double(get(handles.edit_laser_dt, 'string')); % [sec] dt used by the laser between 2 PIV images
    wingspan = str2double(get(handles.edit_b, 'string')); % [m] bird's wingspan that includes the body width
    body_l = str2double(get(handles.edit_bl, 'string')); % [m] bird's body length
    body_w = str2double(get(handles.edit_bw, 'string')); % [m] bird's body width
    weight = str2double(get(handles.edit_w, 'string')); % [kg] bird's weight
    viscosity = str2double(get(handles.edit_viscosity, 'string')); % [Pa*sec] Air viscosity
    horizontal_cut = str2double(get(handles.edit_h_cut, 'string')); % Horizontal cut the user want to perform for the PIV velocity maps
    vertical_cut = str2double(get(handles.edit_v_cut, 'string')); % Vertical cut the user want to perform for the PIV velocity maps

    INPUTS = [laser_dt, p_cm, dt, chord, wingspan, body_l, body_w, weight,...
    Uinf, density, viscosity, horizontal_cut, vertical_cut,...
    Wingbeats_start, Wingbeats_end];

    % calculating the drag
    [x_c, time, Cd_steady, Cd_unsteady] = drag_force(MAT_file, INPUTS); % Drag force calculation algorithm
    close(h)

end
    


% --- Executes on selection change in popupmenu_colormap.
function popupmenu_colormap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_colormap
plot_axes(handles, 1)


% --- Executes during object creation, after setting all properties.
function popupmenu_colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function plot_lift_Callback(hObject, eventdata, handles)
% hObject    handle to plot_lift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global MAT_file;
global LIFT_method;

% close figure(1) if it's exist
if ishandle(1)==1
    close(figure(1));
end

if isempty(MAT_file)==1
    name = ('Please load a .mat file first!');
    msgbox(name,  'Error','error');
else
    if isempty(DOWNSTROKE)==1
        name = ('Please enter kinematic database before calculating drag!');
        msgbox(name, 'Error','error');
    else      
        [x_c, time, CIRC_NORM, Cl_circ] = calc_lift(handles); % Calculating the commulative lift coefficient 
        h = waitbar(100/100, 'Unsteady lift plot finished!');
        close (h);
        max_time = max(time);

        No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
        x_axis = getCurrentPopupString(handles.popupmenu_x_axis); % x axis chosen by the user
        x_c_gap = str2double(get(handles.edit_x_c_gap, 'string')); % Gap for the first wingbeat in x/c length
        Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from
        ni = str2double(get(handles.edit_ni, 'string')); % Initial velocity map in the sequence
        nf = str2double(get(handles.edit_nf, 'string')); % Final velocity map in the sequence
        
        wingbeats_number = No_wingbeats - Start_wingbeat + 1;

        usds = get(handles.radiobutton_usds, 'Value');
        dsus = get(handles.radiobutton_dsus, 'Value');

        % Plotting the drag variation with time
        figure(1);
        ax1 = axes;
        labelsize = 16; % fontsize of the labels
        fontname = 'Times New Roman'; % font name
        axessize = 14; % fontsize of the axes  

        switch x_axis
            case 'x_c'
            moving_avg = 5;
%             moving_avg = round(0.05*length(Cl_circ));
            h1 = plot(x_c+x_c_gap, smooth(Cl_circ, moving_avg), 'color', 'b', 'linewidth', 3, 'linestyle', '-'); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$x/c$', 'interpreter', 'latex', 'fontsize', labelsize);   

            case 't_T'
            moving_avg = 5;
            if wingbeats_number>1
                h1 = plot(time, smooth(Cl_circ, moving_avg), 'color', 'b','linewidth', 3, 'linestyle', '-'); hold on;
                set(ax1, 'fontname', fontname, 'fontsize', axessize);
                xlabel(ax1, '$t~[\mathrm{sec}]$', 'interpreter', 'latex', 'fontsize', labelsize);
            else
                h1 = plot(time./max_time, smooth(Cl_circ, moving_avg), 'color', 'b','linewidth', 3, 'linestyle', '-'); hold on;
                set(ax1, 'fontname', fontname, 'fontsize', axessize);
                xlabel(ax1, '$t/T$', 'interpreter', 'latex', 'fontsize', labelsize);
            end
        end

        ylabel(ax1, '$\Delta C_{l_{circ}}$', 'interpreter', 'latex', 'fontsize', labelsize,...
            'rotation', 0, 'horizontalAlignment', 'right', 'verticalAlignment', 'middle');
        set(ax1, 'box', 'off');

        % get the limits of the y axis
        y_lim = get(gca, 'ylim');

        % Get the x value of the different phases
        down = zeros(1, wingbeats_number);
        up = zeros(1, wingbeats_number);
        trans = zeros(1, wingbeats_number);
        for i=1:wingbeats_number
            if dsus>usds
                x_axis_h1 = h1.XData;
                n = i + Start_wingbeat - 1;
                if LIFT_method>2
                    down_ind = DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    down(i) = x_axis_h1(down_ind); % value of the x axis for the start of the downstroke phase
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    up(i) = x_axis_h1(up_ind); % value of the x axis for the end of the upstroke phase
                else
                    down_ind = DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    tmp1 = round((down_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp2 = round((trans_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp3 = round((up_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    if tmp1==0 
                        down(i) = x_axis_h1(1);
                    else
                        down(i) = x_axis_h1(tmp1); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp2==0 
                        trans(i) = x_axis_h1(1);
                    else
                        trans(i) = x_axis_h1(tmp2); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp3==0 
                        up(i) = x_axis_h1(1);
                    else
                        up(i) = x_axis_h1(tmp3); % value of the x axis for the start of the downstroke phase
                    end
                end
            elseif usds>dsus
                x_axis_h1 = h1.XData;
                n = i + Start_wingbeat - 1;
                if LIFT_method>2
                    down_ind = DOWNSTROKE(n) - UPSTROKE(Start_wingbeat) + 1; % index of the end of the downstroke phase 
                    down(i) = x_axis_h1(down_ind); % value of the x axis for the end of the downstroke phase 
                    trans_ind = TRANSITION(n) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase
                    trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the downstroke phase
                    up_ind = UPSTROKE(n) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up(i) = x_axis_h1(up_ind); % value of the x axis for the start of the upstroke phase
                else
                    down_ind = DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    tmp1 = round((down_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp2 = round((trans_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp3 = round((up_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    if tmp1==0 
                        down(i) = x_axis_h1(1);
                    else
                        down(i) = x_axis_h1(tmp1); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp2==0 
                        trans(i) = x_axis_h1(1);
                    else
                        trans(i) = x_axis_h1(tmp2); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp3==0 
                        up(i) = x_axis_h1(1);
                    else
                        up(i) = x_axis_h1(tmp3); % value of the x axis for the start of the downstroke phase
                    end
                end
            end
        end
        
        % set x limits
        x_max = max(x_axis_h1);
        x_min = min(x_axis_h1);
        set(gca, 'xlim', [x_min x_max]);      

        % Paint in gray the upstroke phase
        for i=1:wingbeats_number
            if dsus>usds % Painting in gray the upstroke phase
                area([trans(i) up(i)],[y_lim(1) y_lim(1)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                area([trans(i) up(i)],[y_lim(2) y_lim(2)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            elseif usds>dsus % Painting in gray the upstroke phase
                area([up(i) trans(i)],[y_lim(1) y_lim(1)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                area([up(i) trans(i)],[y_lim(2) y_lim(2)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            end
        end   

        % Plot a line on y=0
        plot([x_axis_h1(1) x_axis_h1(end)], [0 0], '--','color',[.5 .5 .5], 'linewidth', 2); hold on;
        

        uistack(h1, 'top');
        set(ax1, 'layer', 'top');
   
% 
%         if dsus == 1
%             text((trans_dx_c+x_c(1))/2 - 0.11, -0.15, 'downstroke', 'fontsize', labelsize, 'fontname', fontname);
%             text((x_c(end) + trans_dx_c)/2 - 0.15, -0.15, 'upstroke', 'fontsize', labelsize, 'fontname', fontname);
%         elseif usds == 1
%             text((trans_dx_c+x_c(1))/2 - 0.15, -0.15, 'upstroke', 'fontsize', labelsize, 'fontname', fontname);
%             text((x_c(end) + trans_dx_c)/2 - 0.11, -0.15, 'downstroke', 'fontsize', labelsize, 'fontname', fontname);
%         end
        
    end
    
end


% --------------------------------------------------------------------
function save_lift_Callback(hObject, eventdata, handles)
% hObject    handle to save_lift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global MAT_file;
global LIFT_method;


% close figure(1) if it's exist
if ishandle(1)==1
    close(figure(1));
end

if isempty(MAT_file)==1
    name = ('Please load a .mat file first!');
    msgbox(name,  'Error','error');
else
    if isempty(DOWNSTROKE)==1
        name = ('Please enter kinematic database before calculating drag!');
        msgbox(name, 'Error','error');
    else
        [filename, pathname, filterindex] = uiputfile( ...
               {'*.tiff','TIFF File (*.tiff)'; '*.jpg','JPEG File (*.jpg)';...
               '*.pdf','PDF File (*.pdf)'; '*.png','PNG File (*.png)';...
               '*.fig','Figures (*.fig)'; '*.tiff;*.jpg;*.pdf;*.png;*.fig',...
               'All MATLAB Files (*.tiff, *.jpg, *.pdf, *.png, *.fig)';...
               '*.*',  'All Files (*.*)'}, 'Save as');
        if pathname == 0 %if the user pressed cancelled, then we exit this callback
            return
        end
        
        path = fullfile(pathname, filename); % Concentrate the two strings to one path

        [x_c, time, CIRC_NORM, Cl_circ] = calc_lift(handles); % Calculating the commulative lift coefficient 
        h = waitbar(65/100, 'Saving figure. Please wait!');
        max_time = max(time);
        
        No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
        x_axis = getCurrentPopupString(handles.popupmenu_x_axis); % x axis chosen by the user
        x_c_gap = str2double(get(handles.edit_x_c_gap, 'string')); % Gap for the first wingbeat in x/c length
        Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from

        wingbeats_number = No_wingbeats - Start_wingbeat + 1;

        usds = get(handles.radiobutton_usds, 'Value');
        dsus = get(handles.radiobutton_dsus, 'Value');

        
        % Plotting the drag variation with time
        fig1 = figure(1);
        ax1 = axes;
        labelsize = 38; % fontsize of the labels
        fontname = 'Times New Roman'; % font name
        axessize = 25; % fontsize of the axes  

        switch x_axis
            case 'x_c'
            moving_avg = 5;
            h1 = plot(x_c+x_c_gap, smooth(Cl_circ, moving_avg), 'color', 'b', 'linewidth', 3,...
                'linestyle', '-'); hold on;
            set(ax1, 'fontname', fontname, 'fontsize', axessize);
            xlabel(ax1, '$x/c$', 'interpreter', 'latex', 'fontsize', labelsize);   

            
            case 't_T'
            moving_avg = 5;
            if wingbeats_number>1
                h1 = plot(time, smooth(Cl_circ, moving_avg), 'color', 'b','linewidth', 3, 'linestyle', '-'); hold on;
                set(ax1, 'fontname', fontname, 'fontsize', axessize);
                xlabel(ax1, '$t~[\mathrm{sec}]$', 'interpreter', 'latex', 'fontsize', labelsize);
            else
                h1 = plot(time./max_time, smooth(Cl_circ, moving_avg), 'color', 'b','linewidth', 3, 'linestyle', '-'); hold on;
                set(ax1, 'fontname', fontname, 'fontsize', axessize);
                xlabel(ax1, '$t/T$', 'interpreter', 'latex', 'fontsize', labelsize);
            end
        end

        ylabel(ax1, '$\Delta C_{l_{circ}}$', 'interpreter', 'latex', 'fontsize', labelsize,...
            'rotation', 0, 'horizontalAlignment', 'right', 'verticalAlignment', 'middle');
        set(ax1, 'box', 'off');

        set(fig1,'units','normalized','outerposition',[0 0 1 1]); % enlarging the figure to fullscreen 
        set(fig1, 'PaperType', 'B4', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
        
        % get the limits of the y axis
        y_lim = get(gca, 'ylim');

        % Get the x value of the different phases
        down = zeros(1, wingbeats_number);
        up = zeros(1, wingbeats_number);
        trans = zeros(1, wingbeats_number);
        for i=1:wingbeats_number
            if dsus>usds
                n = i + Start_wingbeat - 1;
                x_axis_h1 = h1.XData;
                if LIFT_method>2
                    down_ind= DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    down(i) = x_axis_h1(down_ind); % value of the x axis for the start of the downstroke phase
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    up(i) = x_axis_h1(up_ind); % value of the x axis for the end of the upstroke phase
                else
                    down_ind = DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    tmp1 = round((down_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp2 = round((trans_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp3 = round((up_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    if tmp1==0 
                        down(i) = x_axis_h1(1);
                    else
                        down(i) = x_axis_h1(tmp1); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp2==0 
                        trans(i) = x_axis_h1(1);
                    else
                        trans(i) = x_axis_h1(tmp2); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp3==0 
                        up(i) = x_axis_h1(1);
                    else
                        up(i) = x_axis_h1(tmp3); % value of the x axis for the start of the downstroke phase
                    end
                end
            elseif usds>dsus
                n = i + Start_wingbeat - 1;
                x_axis_h1 = h1.XData;
                if LIFT_method>2
                    down_ind = DOWNSTROKE(n) - UPSTROKE(Start_wingbeat) + 1; % index of the end of the downstroke phase 
                    down(i) = x_axis_h1(down_ind); % value of the x axis for the end of the downstroke phase 
                    trans_ind = TRANSITION(n) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase
                    trans(i) = x_axis_h1(trans_ind); % value of the x axis for the start of the downstroke phase
                    up_ind = UPSTROKE(n) - UPSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up(i) = x_axis_h1(up_ind); % value of the x axis for the start of the upstroke phase
                else
                    down_ind = DOWNSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the downstroke phase 
                    trans_ind = TRANSITION(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the start of the upstroke phase
                    up_ind = UPSTROKE(n) - DOWNSTROKE(Start_wingbeat) + 1; % index of the end of the upstroke phase
                    tmp1 = round((down_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp2 = round((trans_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    tmp3 = round((up_ind-1)/(nf-ni+1)*length(x_axis_h1));
                    if tmp1==0 
                        down(i) = x_axis_h1(1);
                    else
                        down(i) = x_axis_h1(tmp1); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp2==0 
                        trans(i) = x_axis_h1(1);
                    else
                        trans(i) = x_axis_h1(tmp2); % value of the x axis for the start of the downstroke phase
                    end
                    if tmp3==0 
                        up(i) = x_axis_h1(1);
                    else
                        up(i) = x_axis_h1(tmp3); % value of the x axis for the start of the downstroke phase
                    end
                end
            end
        end
        
        % set x limits
        x_max = max(x_axis_h1);
        x_min = min(x_axis_h1);
        set(gca, 'xlim', [x_min x_max]);                 

        % Paint in gray the upstroke phase
        for i=1:wingbeats_number
            if dsus>usds % Painting in gray the upstroke phase
                area([trans(i) up(i)],[y_lim(1) y_lim(1)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                area([trans(i) up(i)],[y_lim(2) y_lim(2)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            elseif usds>dsus % Painting in gray the upstroke phase
                area([up(i) trans(i)],[y_lim(1) y_lim(1)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
                area([up(i) trans(i)],[y_lim(2) y_lim(2)]*0.998,'FaceColor',[.85 .85 .85], 'EdgeColor','none'); hold on;
            end
        end   

        % Plot a line on y=0
        plot([x_axis_h1(1) x_axis_h1(end)], [0 0], '--','color',[.5 .5 .5], 'linewidth', 2); hold on;
        

        uistack(h1, 'top');
        set(ax1, 'layer', 'top');

%         if dsus == 1
%             text((trans_dx_c+x_c(1))/2 - 0.06, -0.15, 'downstroke', 'fontsize', legendsize, 'fontname', fontname);
%             text((x_c(end) + trans_dx_c)/2 - 0.08, -0.15, 'upstroke', 'fontsize', legendsize, 'fontname', fontname);
%         elseif usds == 1
%             text((trans_dx_c+x_c(1))/2 - 0.08, -0.15, 'upstroke', 'fontsize', legendsize, 'fontname', fontname);
%             text((x_c(end) + trans_dx_c)/2 - 0.06, -0.15, 'downstroke', 'fontsize', legendsize, 'fontname', fontname);
%         end
        
        close (h);
        h = waitbar(85/100, 'Saving figure. Please wait!');
        if filterindex == 1 % if the user want to save a tiff image
            print(fig1, path, '-dtiff', '-r600');
        elseif filterindex == 2 % if the user want to save a jpeg image
            print(fig1, path, '-djpeg', '-r600');
        elseif filterindex == 3 % if the user want to save a tiff image
            set(fig1, 'PaperType', 'B4', 'PaperOrientation', 'landscape', 'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
            print(fig1, path, '-dpdf', '-r600');
        elseif filterindex == 4 % if the user want to save a png image
            print(fig1, path, '-dpng', '-r600');
        else
            saveas(fig1, path); % saving the image according to the specified format by the user
        end
        close(h);
        h = waitbar(100/100, 'Figure Saved!');
        close(h);

        close(fig1); % closing the new figure
    end
    
end


function [x_c, time, CIRC_NORM, Cl_circ] = calc_lift(handles)
global MAT_file
global MASK
global VORTICITY_NORM
global VORTICITY
global U
global DUDX
global DUDY
global Uinf
global chord
global DOWNSTROKE;
global UPSTROKE;
global LIFT_method;

h = waitbar(50/100, 'Plotting unsteady lift Please wait!');
[~, ~, nTime] = size(MAT_file.uf); % Getting the NEW velocity map size

No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot
usds = get(handles.radiobutton_usds, 'Value');
dsus = get(handles.radiobutton_dsus, 'Value');
Start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % Wingbeat to start from

if dsus>usds
    Wingbeats_start = DOWNSTROKE(Start_wingbeat);
    Wingbeats_end = UPSTROKE(No_wingbeats);
elseif usds>dsus
    Wingbeats_start = UPSTROKE(Start_wingbeat);
    Wingbeats_end = DOWNSTROKE(No_wingbeats);
end

if Wingbeats_end > nTime - 1 || Wingbeats_start < 2
    name = (['Please choose a legit range for the wingbeat cycle! Should be from 2 to ', num2str(nTime-1), '...']);
    msgbox(name,  'Error','error')
else
    p_cm = str2double(get(handles.edit_dp_cm, 'string')); % [pixel/cm] pixel to cm ratio
    dt = str2double(get(handles.edit_dt, 'string')); % [sec] dt between 2 velocity maps
    density = str2double(get(handles.edit_density, 'string')); % [kg/m^3] Air density
    laser_dt = str2double(get(handles.edit_laser_dt, 'string')); % [sec] dt used by the laser between 2 PIV images
    wingspan = str2double(get(handles.edit_b, 'string')); % [m] bird's wingspan that includes the body width
    body_l = str2double(get(handles.edit_bl, 'string')); % [m] bird's body length
    body_w = str2double(get(handles.edit_bw, 'string')); % [m] bird's body width
    weight = str2double(get(handles.edit_w, 'string')); % [kg] bird's weight
    viscosity = str2double(get(handles.edit_viscosity, 'string')); % [Pa*sec] Air viscosity
    horizontal_cut = str2double(get(handles.edit_h_cut, 'string')); % Horizontal cut the user want to perform for the PIV velocity maps
    vertical_cut = str2double(get(handles.edit_v_cut, 'string')); % Vertical cut the user want to perform for the PIV velocity maps
    chord = str2double(get(handles.edit_chord, 'string')); % [m] bird's chord
    Uinf = str2double(get(handles.edit_Uinf, 'string')); % [m/sec] Free stream velocity

    INPUTS = [laser_dt, p_cm, dt, chord, wingspan, body_l, body_w, weight,...
    Uinf, density, viscosity, horizontal_cut, vertical_cut,...
    Wingbeats_start, Wingbeats_end];
    set(handles.edit_ni, 'string', num2str(Wingbeats_start)); % Initial velocity map in the sequence
    set(handles.edit_nf, 'string', num2str(Wingbeats_end)); % Final velocity map in the sequence

    vort_thresh = str2double(get(handles.edit_vort_threshold, 'string')); % Vorticity threshold
     % X fraction of the max VORTICITY_NORM will be eliminated
    if vort_thresh < 0 || vort_thresh > 100
        name = ('Please choose a correct range of vorticity threshold! Should be from 1 to 100...');
        msgbox(name,  'Error','error')
        return;
    end 
    vort_thresh = vort_thresh/100; % precentage to ratio
    
    VORTICITY_w_thresh = VORTICITY_NORM.*(Uinf./chord); % Calculating the vorticity of the wake with the treshold applied
    
    % calculating the vertical momentum
    if LIFT_method<3
        pushbutton_wake_gen_Callback(0, 0, handles);
    end
    [x_c, time, CIRC_NORM, Cl_circ] = lift_force(MAT_file, INPUTS, U, DUDX, DUDY, VORTICITY, VORTICITY_w_thresh, vort_thresh, MASK, LIFT_method); % Vertical momentum calculation algorithm
    close(h)
end
    




function edit_x_c_gap_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x_c_gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x_c_gap as text
%        str2double(get(hObject,'String')) returns contents of edit_x_c_gap as a double


% --- Executes during object creation, after setting all properties.
function edit_x_c_gap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x_c_gap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_set_kinematics.
function pushbutton_set_kinematics_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set_kinematics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;

% Getting the inputs
dsus = get(handles.radiobutton_dsus, 'Value');
usds = get(handles.radiobutton_usds, 'Value');

% Generate the figure
h = figure('name', 'Set Kinematics Info', 'NumberTitle','off');
set(h, 'resize', 'off');
h.Units = 'normalized';
set(h, 'MenuBar','none','position', [0.5 0.5 0.3 0.4]); % set the window size and location

% Generating the wingbeats database table
if isempty(DOWNSTROKE)==1 % generating fresh table
    t = uitable(h, 'Data', zeros(1,3));
else % Generating table based on former info
    if dsus>usds % for downstroke->upstroke wingbeats
        data(:,1) = DOWNSTROKE;
        data(:,2) = TRANSITION;
        data(:,3) = UPSTROKE; 
    elseif usds>dsus % for upstroke->downstroke wingbeats
        data(:,1) = UPSTROKE;
        data(:,2) = TRANSITION;
        data(:,3) = DOWNSTROKE; 
    end
    t = uitable(h, 'Data', data);
end

% Define the table properties
t.Units = 'normalized';
t.Position = [0.3 0.25 0.65 0.6];
t.FontSize = 10;
t.ColumnWidth = 'auto';
t.Tag = 'kinematic_table';
if dsus>usds % for downstroke->upstroke wingbeats
    t.ColumnName = {'Downstroke', 'Transition', 'Upstroke'};
elseif usds>dsus % for upstroke->downstroke wingbeats
    t.ColumnName = {'Upstroke', 'Transition', 'Downstroke'};
end
t.ColumnEditable = true; % allow the user to edit the table

text = uicontrol('Parent',h,'Style','text','String','Please set the kinematics info for the different wingbeats...','FontSize',12, 'units', 'normalized');
text.Position = [0.2 0.875 0.6 0.1];

text2 = uicontrol('Parent', h, 'Style', 'text', 'String', 'Left column - 1st phase start;', 'FontSize', 8, 'units', 'normalized');
text3 = uicontrol('Parent', h, 'Style', 'text', 'String', 'Middle column - 1st phase end;', 'FontSize', 8, 'units', 'normalized');
text4 = uicontrol('Parent', h, 'Style', 'text', 'String', 'Right column - 2nd phase end;', 'FontSize', 8, 'units', 'normalized');
text5 = uicontrol('Parent', h, 'Style', 'text', 'String', '* Insert 0 in case no data is available.', 'FontSize', 8, 'units', 'normalized');

text2.Position = [0.01 0.18 0.35 0.05];
text3.Position = [0.02 0.13 0.35 0.05];
text4.Position = [0.0175 0.08 0.35 0.05];
text5.Position = [0.005 0.02 0.41 0.03];

handlesArray.table = t;

Load_DB_button = uicontrol('Parent',h,'Style','pushbutton','String','Load Database',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.02 0.73 0.27 0.13], ...
    'Callback',{@load_DB, handles, handlesArray});

Export_DB_button = uicontrol('Parent',h,'Style','pushbutton','String','Export Database',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.02 0.6 0.27 0.13], ...
    'Callback',{@export_DB, handles, handlesArray});

Add_rows_button = uicontrol('Parent',h,'Style','pushbutton','String','Add Wingbeat',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.02 0.37 0.27 0.13], ...
    'Callback',{@add_table_rows, handlesArray});

Remove_rows_button = uicontrol('Parent',h,'Style','pushbutton','String','Remove Wingbeat',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.02 0.24 0.27 0.13], ...
    'Callback',{@remove_table_rows, handlesArray});

SAVE_DB_button = uicontrol('Parent',h,'Style','pushbutton','String','Save database',...
    'FontSize',14, 'units', 'normalized', 'Position',[0.4 0.1 0.4 0.13], ...
    'Callback',{@save_DB_button, handles, handlesArray});



function export_DB(hObject, callbackdata, handles, handlesArray)
% Function to save the kinematic databse
% hTable: handle to the table
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global NO_WINGBEATS;

hTable = handlesArray.table;
dsus = get(handles.radiobutton_dsus, 'Value');
usds = get(handles.radiobutton_usds, 'Value');

first_column = hTable.Data(:,1);
second_column = hTable.Data(:,2);
third_column = hTable.Data(:,3);

%% LOCGIC TESTS FOR THE TABLE INPUTS
error_flag = 0;
for i=1:length(first_column)
    
    if second_column(i) <= first_column(i) && second_column(i)>0 && first_column(i)>0
        name = (['Image numbers must be in logic order for the first and second columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif third_column(i) <= second_column(i) && second_column(i)>0 && third_column(i)>0
        name = (['Image numbers must be in logic order for the second and third columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif third_column(i) <= first_column(i) && first_column(i)>0 && third_column(i)>0
        name = (['Image numbers must be in logic order for the first and third columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif i>1 && first_column(i) < third_column(i-1) && third_column(i)>=0 && first_column(i)>=0
        name = (['Image numbers must be in logic order for the first column of wingbeat no. ', num2str(i), ' and the third column of wingbeat no. ' , num2str(i-1), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif first_column(i)<0 || second_column(i)<0 || third_column(i)<0
        name = ('Image numbers must be positive numbers!');
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    end  
end

if error_flag == 0
    if dsus>usds % for downstroke->upstroke wingbeats
        DOWNSTROKE = first_column;
        UPSTROKE = third_column;
    elseif usds>dsus % for upstroke->downstroke wingbeats
        UPSTROKE = first_column;
        DOWNSTROKE = third_column;
    end

    TRANSITION = second_column;
    NO_WINGBEATS = length(DOWNSTROKE);

    % Defining .mat file with all the inputs
    KINEMATICS = [];
    KINEMATICS.DOWNSTROKE = DOWNSTROKE;
    KINEMATICS.UPSTROKE = UPSTROKE;
    KINEMATICS.TRANSITION = TRANSITION;
    KINEMATICS.NO_WINGBEATS = NO_WINGBEATS;
    KINEMATICS.DSUS = dsus;
    KINEMATICS.USDS = usds;

    [filename, pathname, filterindex] = uiputfile({'*.mat','MAT-files (*.mat)'}, 'Export kinematics database as');
    if pathname == 0 %if the user pressed cancelled, then we exit this callback
        return
    end

    path = fullfile(pathname, filename); % Concentrate the two strings to one path

    save(path,'KINEMATICS');
    disp('Kinematics database was exported successfully!');
    name = ('Kinematics database was exported successfully!');
    msgbox(name);
end


function load_DB(hObject, callbackdata, handles, handlesArray)
% Function to add new wingbeat row to a table
% hTable: handle to the table
% newRow : the row of data you want to add to the table.

global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global NO_WINGBEATS;

[FileName,PathName] = uigetfile('*.mat','Select the kinematics database .mat file'); % Let the user select the .mat file
mat_file_name = fullfile(PathName, FileName); % Getting the .mat file name

% Load the .mat file selected by the user
if isequal(FileName,0) 
   disp('User selected Cancel')
   return;
else
   disp(['User selected ', mat_file_name])
end
load(mat_file_name); % Load the .mat file into an array

% Get the kinematics database inputs
DOWNSTROKE = KINEMATICS.DOWNSTROKE;
UPSTROKE = KINEMATICS.UPSTROKE;
TRANSITION = KINEMATICS.TRANSITION;
NO_WINGBEATS = KINEMATICS.NO_WINGBEATS;
dsus = KINEMATICS.DSUS;
usds = KINEMATICS.USDS;

% Setting DSUS/USDS info
set(handles.radiobutton_dsus, 'Value', dsus);
set(handles.radiobutton_usds, 'Value', usds);

% Setting kinematic info
if dsus>usds % for downstroke->upstroke wingbeats
    first_column = DOWNSTROKE;
    third_column = UPSTROKE;
elseif usds>dsus % for upstroke->downstroke wingbeats
    first_column = UPSTROKE;
    third_column = DOWNSTROKE;
end
second_column = TRANSITION;

data = [first_column second_column third_column];

% Set the database into the table
hTable = handlesArray.table;
set(hTable,'Data',data);
if dsus>usds % for downstroke->upstroke wingbeats
    set(hTable, 'ColumnName', {'Downstroke', 'Transition', 'Upstroke'});
elseif usds>dsus % for upstroke->downstroke wingbeats
    set(hTable, 'ColumnName', {'Upstroke', 'Transition', 'Downstroke'});
end

disp('Kinematics database was loaded successfully!');


% Check logical values entered for the wingbeats plotting
value = str2double(get(handles.edit_no_wingbeats_to_plot, 'String'));
if value > NO_WINGBEATS
    set(handles.edit_no_wingbeats_to_plot, 'String', NO_WINGBEATS);
    No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot,'String'));
    
    start_wingbeat = str2double(get(handles.edit_start_wingbeat, 'string')); % start wingbeat to plot

    if No_wingbeats<start_wingbeat
        set(handles.edit_start_wingbeat, 'string', num2str(No_wingbeats));
    end
end




function add_table_rows(hObject, callbackdata, handlesArray)
% Function to add new wingbeat row to a table
% hTable: handle to the table
% newRow : the row of data you want to add to the table.
hTable = handlesArray.table;
newRow = zeros(1,3);
oldData = get(hTable,'Data');
newData = [oldData; newRow];
set(hTable,'Data',newData);


function remove_table_rows(hObject, callbackdata, handlesArray)
% Function to add remove wingbeat row to a table
% hTable: handle to the table
hTable = handlesArray.table;
oldData = get(hTable,'Data');
newData = oldData(1:end-1,:);
set(hTable,'Data',newData);


function save_DB_button(hObject, callbackdata, handles, handlesArray)
global DOWNSTROKE;
global TRANSITION
global UPSTROKE;
global NO_WINGBEATS;

first_column = handlesArray.table.Data(:,1);
second_column = handlesArray.table.Data(:,2);
third_column = handlesArray.table.Data(:,3);

dsus = get(handles.radiobutton_dsus, 'Value');
usds = get(handles.radiobutton_usds, 'Value');

%% LOCGIC TESTS FOR THE TABLE INPUTS
error_flag = 0;
for i=1:length(first_column)
    
    if second_column(i) <= first_column(i) && second_column(i)>0 && first_column(i)>0
        name = (['Image numbers must be in logic order for the first and second columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif third_column(i) <= second_column(i) && second_column(i)>0 && third_column(i)>0
        name = (['Image numbers must be in logic order for the second and third columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif third_column(i) <= first_column(i) && first_column(i)>0 && third_column(i)>0
        name = (['Image numbers must be in logic order for the first and third columns of wingbeat no. ' , num2str(i), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif i>1 && first_column(i) < third_column(i-1) && third_column(i)>=0 && first_column(i)>=0
        name = (['Image numbers must be in logic order for the first column of wingbeat no. ', num2str(i), ' and the third column of wingbeat no. ' , num2str(i-1), '!']);
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    elseif first_column(i)<0 || second_column(i)<0 || third_column(i)<0
        name = ('Image numbers must be positive numbers!');
        msgbox(name,  'Error','error');
        error_flag = 1;
        break;
    end  
end

if error_flag == 0
    if dsus>usds % for downstroke->upstroke wingbeats
        DOWNSTROKE = first_column;
        UPSTROKE = third_column;
    elseif usds>dsus % for upstroke->downstroke wingbeats
        UPSTROKE = first_column;
        DOWNSTROKE = third_column;
    end

    TRANSITION = second_column;
    NO_WINGBEATS = length(DOWNSTROKE);
    disp('Kinematics database was saved successfully!');
    name = ('Kinematics database was saved successfully!');
    msgbox(name);
end



function edit_no_wingbeats_to_plot_Callback(hObject, eventdata, handles)
% hObject    handle to edit_no_wingbeats_to_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_no_wingbeats_to_plot as text
%        str2double(get(hObject,'String')) returns contents of edit_no_wingbeats_to_plot as a double
global DOWNSTROKE;

if isempty(DOWNSTROKE) == 0
    value = str2double(get(hObject,'String'));
    if value > length(DOWNSTROKE)
        name = ('No. of wingbeats to be shown is larger than those exist in the database!');
        msgbox(name,  'Error','error');
        value = length(DOWNSTROKE);
        set(hObject, 'String', num2str(value));
    end
end

No_wingbeats = str2double(get(hObject,'String'));
value = str2double(get(handles.edit_start_wingbeat, 'string')); % start wingbeat to plot

if No_wingbeats<value
    name = ('The stop wingbeat is smaller than the start wingbeat!');
    msgbox(name,  'Error','error');
    set(handles.edit_no_wingbeats_to_plot, 'string', num2str(value));
elseif value<1
    name = ('The stop wingbeat must be an integer larger than 0!');
    msgbox(name,  'Error','error');
    set(handles.edit_no_wingbeats_to_plot, 'string', num2str(1));
elseif value <= 0 || floor(value)~=ceil(value) % logical test for a round number
    name = ('The stop wingbeat must be an integer larger than 0!');
    msgbox(name,  'Error', 'error');
    set(handles.edit_no_wingbeats_to_plot, 'string', num2str(1));
end


% --- Executes during object creation, after setting all properties.
function edit_no_wingbeats_to_plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_no_wingbeats_to_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_x_axis.
function popupmenu_x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_x_axis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_x_axis


% --- Executes during object creation, after setting all properties.
function popupmenu_x_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_start_wingbeat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start_wingbeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_start_wingbeat as text
%        str2double(get(hObject,'String')) returns contents of edit_start_wingbeat as a double
value = str2double(get(hObject,'String'));
No_wingbeats = str2double(get(handles.edit_no_wingbeats_to_plot, 'string')); % No. of wingbeats to plot

if No_wingbeats<value
    name = ('The start wingbeat is larger than the stop wingbeat!');
    msgbox(name,  'Error','error');
    set(handles.edit_start_wingbeat, 'string', num2str(No_wingbeats));
elseif value<1
    name = ('The start wingbeat must be an integer larger than 0!');
    msgbox(name,  'Error','error');
    set(handles.edit_start_wingbeat, 'string', num2str(1));
elseif value <= 0 || floor(value)~=ceil(value) % logical test for a round number
    name = ('The start wingbeat must be an integer larger than 0!');
    msgbox(name,  'Error', 'error');
    set(handles.edit_start_wingbeat, 'string', num2str(1));
end

% --- Executes during object creation, after setting all properties.
function edit_start_wingbeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start_wingbeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function lift_circ_method_Callback(hObject, eventdata, handles)
% hObject    handle to lift_circ_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global LIFT_method

h = figure('name', 'Lift Computation Method', 'NumberTitle','off');
set(h, 'resize', 'off');
h.Units = 'normalized';
set(h, 'MenuBar','none','position', [0.5 0.5 0.29 0.1]); % set the window size and location

% generating the different objects
hp = uipanel('Position',[0 0 1 1]); % 

masking_menu = uicontrol('Parent', hp, 'Style','popupmenu', 'tag', 'masking_menu', 'String',{'Panda & Zaman (1994), based on generated wake',...
    'Panda & Zaman (1994), based on generated wake (threshold applied)', 'Panda & Zaman (1994), based on PIV individual maps (threshold applied)',...
    'Circulation summation'},...
    'FontSize',10, 'units', 'normalized', 'Position',[0.05 0.7 0.9 0.15]);

% setting the current mask used
if LIFT_method == 1
    set(masking_menu, 'string', {'Panda & Zaman (1994), based on generated wake',...
    'Panda & Zaman (1994), based on generated wake (threshold applied)', 'Panda & Zaman (1994), based on PIV individual maps (threshold applied)',...
    'Circulation summation'});
elseif LIFT_method == 2
    set(masking_menu, 'string', {'Panda & Zaman (1994), based on generated wake (threshold applied)',...
    'Panda & Zaman (1994), based on generated wake', 'Panda & Zaman (1994), based on PIV individual maps (threshold applied)',...
    'Circulation summation'});
elseif LIFT_method == 3
    set(masking_menu, 'string', {'Panda & Zaman (1994), based on PIV individual maps (threshold applied)',...
        'Panda & Zaman (1994), based on generated wake', 'Panda & Zaman (1994), based on generated wake (threshold applied)',...
        'Circulation summation'});
elseif LIFT_method == 4
    set(masking_menu, 'string', {'Circulation summation', 'Panda & Zaman (1994), based on generated wake',...
    'Panda & Zaman (1994), based on generated wake (threshold applied)', 'Panda & Zaman (1994), based on PIV individual maps (threshold applied)'});
end

handlesArray.masking_menu = masking_menu;

OK_button = uicontrol('Parent',hp,'Style','pushbutton','String','OK',...
    'FontSize',12, 'units', 'normalized', 'Position',[0.35 0.18 0.3 0.3], ...
    'Callback',{@lift_method_button, handlesArray, h});


function lift_method_button(hObject, callbackdata, handlesArray, h)
global LIFT_method
tmp = getCurrentPopupString(handlesArray.masking_menu);
if strcmp(tmp, 'Panda & Zaman (1994), based on generated wake') == 1
    LIFT_method = 1;
elseif strcmp(tmp, 'Panda & Zaman (1994), based on generated wake (threshold applied)') == 1
    LIFT_method = 2;
elseif strcmp(tmp, 'Panda & Zaman (1994), based on PIV individual maps (threshold applied)') == 1
    LIFT_method = 3;
elseif strcmp(tmp, 'Circulation summation') == 1
    LIFT_method = 4;
end
close(h);


% --- Executes on button press in pushbutton_dCl.
function pushbutton_dCl_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_dCl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_lift_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton_drag.
function pushbutton_drag_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_drag_Callback(hObject, eventdata, handles)
