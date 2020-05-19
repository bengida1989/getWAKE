function contourxy_not_scaled(x_axis1, y_axis, c_axis, color_bar, fonts, q_axis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAST UPDATE IN: 20/09/2016
% By: Hadar Ben-Gida
% Update 1.3
%   Levelstep have been added to the contourf images, to allow better wake
%   image. The default value is set to 5% of the contour limits chosen by
%   the user for the wake 


% Plot contour figure with 2 x-axes
% Last update by Hadar Ben-Gida at 18/10/2015
%
% xaxis1 = {1} - x1 values            (vector)
%          {2} - x1 label             (string)
%          {3} - x1 limits            (vector)
% xaxis2 = {1} - x2 values            (vector)
%          {2} - x2 label             (string)
%          {3} - x2 limits            (vector)
% yaxis  = {1} - y values             (vector)
%          {2} - y label              (string)
%          {3} - y limits             (vector)
% caxis  = {1} - c values             (2D matrix)
%          {2} - c label              (string)
%          {3} - c limits             (vector)
%
%
% OPTIONAL: COLORBAR:
% color_bar  = {1} - color map            (2D matrix)
%              {2} - colorbar delta ticks (double) 
%
%
% OPTIONAL: COLORBAR:
% fonts  = {1} - labels font size     (double)
%          {2} - font name            (string)
%          {3} - axes font size       (double)
%
%
% OPTIONAL: Plotting markers related to the 1st axes:
% markers = {1} - x axis of the markers(vector)
%           {2} - y axis of the markers(vector)
%           {3} - Markers Symbol       (string)
%           {4} - Markers Color        (string)
%           {5} - Markers Size         (double)          
%           {6} - Markers Linewidth    (double)
%
%
% OPTIONAL: Plotting quiver related to the 1st axes:
% q_axis = {1} - u velocity (vector)
%          {2} - v velocity (vector)
%          {3} - Line Width of  arrows (double)
%          {4} - Auto scale factor of arrows (double)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% VARIFYING INFO
% Checking no. of inputs to varify if markers is needed or not
if nargin < 3
   error('Not enough input arguments')
elseif nargin==3
   % Use empty strings for color_bar, fonts and markers
   color_bar='';
   fonts='';
   q_axis='';
elseif nargin==4
   % Use empty strings for fonts and markers
   fonts='';
   q_axis='';
elseif nargin==5
   % Use empty strings for quivers
   q_axis='';
elseif nargin > 6   
   error('Too many input arguments')
end


% Checking no. of xaxis1 inputs
x_lim1 = 'xlim';
if length(x_axis1) < 3
    x_axis1{3} = '';
end;
if isempty(x_axis1{2}) == 1
   x_axis1{2} = ' ';
elseif isempty(x_axis1{3}) == 1
   x_axis1{3} = 'auto';
   x_lim1 = 'xLimMode';
end


% Checking no. of yaxis inputs
y_lim = 'ylim';
if length(y_axis) < 3
    y_axis{3} = '';
end;
if isempty(y_axis{2}) == 1
   y_axis{2} = ' ';
elseif isempty(y_axis{3}) == 1
   y_axis{3} = 'auto';
   y_lim = 'yLimMode';
end

% Checking no. of caxis inputs
c_tick = 'Ticks';
c_ticklabel = 'TickLabels';
if length(c_axis) < 3
    c_axis{3} = '';
end;
if isempty(c_axis{2}) == 1
   c_axis{2} = ' ';
elseif isempty(c_axis{3}) == 1
   c_limits = 'auto';
   c_limits_color = 'auto';
   c_tick = 'TicksMode';
   c_ticklabel = 'TickLabelsMode';
end

% Checking no. of colorbar inputs
if isempty(color_bar) == 0
    if isempty(color_bar{1}) == 1
        color_bar{1} = '';
    elseif isempty(color_bar{2}) == 1
        color_bar{2} = '';
    end
else
    color_bar{1} = '';
    color_bar{2} = '';
end;

% Checking no. of q_axis inputs
if isempty(q_axis) == 0
    if isempty(q_axis{1}) == 1
        error('Not enough quiver input arguments')
    elseif isempty(q_axis{2}) == 1
        error('Not enough quiver input arguments')
    end
end;
%%



%% GETTING THE INPUTS
x1 = x_axis1{1}; % x1 values
x1_label = x_axis1{2}; % x1 label
x1_limits = x_axis1{3}; % x1 limits

y = y_axis{1}; % y
y_label = y_axis{2}; % y label
y_limits = y_axis{3}; % y limits

color_map = color_bar{1}; % colormap
color_dticks = color_bar{2}; % colorbar delta ticks

c = c_axis{1}; % c values
c_label = c_axis{2}; % c label
if isempty(c_axis{3}) == 0 &&  isempty(color_dticks) == 0 % in case c_axis{3} and color_bar{2} are not empty
    c_limits_color = c_axis{3}(1):color_dticks:c_axis{3}(end); % for colorbar labels
    c_limits = c_axis{3}; % for limits of caxis
elseif isempty(c_axis{3}) == 0 &&  isempty(color_dticks) == 1% in case c_axis{3} is not empty and color_bar{2} is empty
    c_limits_color = 'auto';
    c_tick = 'TicksMode';
    c_ticklabel = 'TickLabelsMode';
    c_limits = c_axis{3}; % for limits of caxis
end;


if isempty(fonts) == 0 % in case fonts is not empty
    labelsize = fonts{1}; % labels font size
    fontname = fonts{2}; % font name
    axessize = fonts{3}; % axes font size
elseif isempty(fonts) == 1 % in case fonts is  empty
    labelsize = ''; % labels font size
    fontname = ''; % font name
    axessize = ''; % axes font size
end;


% Setting quiver inputs
if isempty(q_axis) == 0
    q_u = q_axis{1}; % u values
    q_v = q_axis{2}; % v values
    q_linew = q_axis{3}; % q line width
    q_scale = q_axis{4}; % q scale
    q_del = q_axis{5}; % Vector spacing
end;
%%



%% PLOTTING
if isempty(color_map) == 0 % if a colorbar was defined
    colormap(color_map); % define the colormap for the contours
end;

levelstep = 0.05*(abs(c_axis{3}(1)) + abs(c_axis{3}(2))); % 5% level step in the contour for displaying the wake
[c1, h1] = contourf(x1, y, c, 'linestyle', 'none', 'levelstepmode', 'manual', 'levelstep', levelstep); hold on; % plotting the contours

if isempty(q_axis) == 0
    del = q_del;
    if isempty(q_linew) == 1 && isempty(q_scale) == 0
        quiver(x1(1:del:end), y(1:del:end), q_u(1:del:end), q_v(1:del:end), 'k', 'AutoScaleFactor', q_scale); hold on; % plotting the quiver  
    elseif isempty(q_linew) == 0 && isempty(q_scale) == 1
        quiver(x1(1:del:end), y(1:del:end), q_u(1:del:end), q_v(1:del:end), 'k', 'linewidth', q_linew); hold on; % plotting the quiver    
    elseif isempty(q_linew) == 1 && isempty(q_scale) == 1
        quiver(x1(1:del:end), y(1:del:end), q_u(1:del:end), q_v(1:del:end), 'k'); hold on; % plotting the quiver           
    else
        quiver(x1(1:del:end), y(1:del:end), q_u(1:del:end), q_v(1:del:end), 'k', 'linewidth', q_linew, 'AutoScaleFactor', q_scale); hold on;
    end;
end;

Ax1 = gca; % getting the 1st axes
set(Ax1, 'box', 'off'); % cutting the box around the plot
set(Ax1, x_lim1, x1_limits); % setting the 1st x-axis limits
IX1 = xlabel(Ax1, x1_label); % setting the x_label for the 1st axes


if isempty(color_dticks) == 0
    h=colorbar(Ax1, c_tick, c_limits_color, c_ticklabel, c_limits_color); % setting the colorbar
else
    h = colorbar(Ax1);
end;

if isempty(labelsize) == 1 && isempty(fontname) == 0
    title(h, c_label, 'FontName', fontname); % setting the colobar title (contours)
elseif isempty(fontname) == 1 && isempty(labelsize) == 0
    title(h, c_label, 'FontSize', labelsize); % setting the colobar title (contours)
elseif isempty(labelsize) == 1 && isempty(fontname) == 1
    title(h, c_label);
else
    title(h, c_label, 'FontName', fontname, 'FontSize', labelsize); % setting the colobar title (contours)
end;

caxis(Ax1, 'manual'); % defining manual contours limits
caxis(Ax1, c_limits); % defining contours limits

axis on;

IY = ylabel(Ax1, y_label, 'rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'Middle'); % arranging the y_label
set(Ax1, y_lim, y_limits); % setting y_axis limits

set(IX1,'interpreter','latex'); % setting latex interpreter
set(IY,'interpreter','latex'); % setting latex interpreter

if isempty(labelsize) == 1 && isempty(fontname) == 0
    set(findall(Ax1, 'Type','text'), 'fontname', fontname) % 1st axes - setting fonts to all labels
    set(Ax1, 'fontname', fontname, 'fontsize', axessize); % 1st axes - setting fonts to x,y axes
elseif isempty(fontname) == 1 && isempty(labelsize) == 0
    set(findall(Ax1, 'Type','text'), 'FontSize', labelsize) % 1st axes - setting fonts % size to all labels
    set(Ax1, 'fontsize', axessize); % 1st axes - setting fonts % size to x,y axes
elseif isempty(labelsize) == 0 && isempty(fontname) == 0
    set(findall(Ax1, 'Type','text'), 'fontname', fontname, 'FontSize', labelsize) % 1st axes - setting fonts % size to all labels
    set(Ax1, 'fontname', fontname, 'fontsize', axessize); % 1st axes - setting fonts % size to x,y axes
end;

% set(Ax1, 'DataAspectRatio', [1 1 1]); hold on; % setting aspect ratio for the 1st axes

% set(gcf,'units','normalized','outerposition',[0 0 1 1]); % enlarging the figure to fullscreen
% 
% set(gcf,'PaperPositionMode','auto'); % settings to prepare the figure for print in the right size
