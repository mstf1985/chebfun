function varargout = isosurface(f, varargin)
%ISOSURFACE  Extract isosurface data from a CHEBFUN3
%
%   ISOSURFACE(F) plots isosurfaces of the CHEBFUN3 object F as a 
%   GUI so that the user can use a slider to change the isosurface.
%
%   ISOSURFACE(F, 'NOSLIDER') plots isosurfaces of the CHEBFUN3 object F at 
%   three automatically-chosen level surfaces. The slider is not shown
%   anymore.
%
%   ISOSURFACE(F, LEV) plots isosurfaces of F at levels specified in the row
%   vector LEV. At most 3 isosurfaces are allowed.
%
%   Example 1: f = chebfun3.gallery3('runge');
%            isosurface(f, [0.8])
%            isosurface(f, [0.8, 0.4])
%
%   ISOSURFACE(F,LEV,...) allows plotting isosurfaces of F at specified 
%   levels, colors and styles.
%
%   If F is complex-valued, then its complex magnitude is used.
%
%   See also CHEBFUN3/PLOT, CHEBFUN3/SLICE, SCAN, and CHEBFUN3/SURF.
%
% Example 2: f = chebfun3(@(x,y,z) tanh(x+y-.3) + cos(x.*y.*z)./(4+x-y-z));
%            isosurface(f)

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

if ( nargin == 1 )
        runIsosurface3GUI(f);
else
    holdState = ishold;
    dom = f.domain;
    numpts = 51;
    [xx, yy, zz] = meshgrid(linspace(dom(1), dom(2), numpts), ...
        linspace(dom(3), dom(4), numpts), linspace(dom(5), dom(6), numpts));
    v = feval(f, xx, yy, zz);
    if ( ~isreal(v) )
        v = abs(v);
    end
end

if ( nargin == 2 && strcmp(varargin, 'noslider') ) % Levels are not specified. So, choose 3 levels yourself.
    fMin = min(v(:)); 
    fMax = max(v(:)); 
    fMean = (fMin + fMax)/2;
    isoval1 = (fMin + fMean)/2; 
    isoval2 = fMean; 
    isoval3 = (fMean + fMax)/2;
    p = patch(isosurface(xx, yy, zz, v, isoval1));
    p.FaceColor = 'red'; 
    p.EdgeColor = 'none';
    hold on
    p = patch(isosurface(xx, yy, zz, v, isoval2));
    p.FaceColor = 'green'; 
    p.EdgeColor = 'none';
    p = patch(isosurface(xx, yy, zz, v, isoval3));
    p.FaceColor = 'blue'; 
    p.EdgeColor = 'none';
    
    % Make objects transparent.
    alpha(.4) 
    
    hold off; 
    %camlight; 
    camlight('headlight')
    lighting gouraud
    view(3)
    title('Three level surfaces');
    xlim([dom(1) dom(2)])
    ylim([dom(3) dom(4)])
    zlim([dom(5) dom(6)])    
    legend(sprintf('%3.2f', isoval1), sprintf('%3.2f', isoval2), ...
        sprintf('%3.2f', isoval3));
    axis tight
    if ( ~holdState )
        hold off
    end
     if ( nargout > 0 )
         varargout = {p};
     end    
     return
    
elseif ( nargin == 2 )
    % Levels are already given but colors and style are not.
    if iscell(varargin(1))
        isovals = cell2mat(varargin(1));
    else
        isovals = varargin(1);
    end
    
    if ( numel(isovals) == 1 )
         p = patch(isosurface(xx, yy, zz, v, isovals));
         p.FaceColor = 'green'; 
         p.EdgeColor = 'none';
         
        isosurface(xx, yy, zz, v, isovals);
        camlight('headlight')
        lighting gouraud
        view(3)
        xlim([dom(1) dom(2)])
        ylim([dom(3) dom(4)])
        zlim([dom(5) dom(6)])
        if ( ~holdState )
            hold off
        end
        if ( nargout > 0 )
            varargout = {p};
        end        
        
    elseif ( numel(isovals)==2 ) % Two levels are already given but colors are not.
        isoval1 = isovals(1); 
        isoval2 = isovals(2);
        p = patch(isosurface(xx, yy, zz, v, isoval1));
        p.FaceColor = 'red'; 
        p.EdgeColor = 'none';
        hold on
        p = patch(isosurface(xx, yy, zz, v, isoval2));
        p.FaceColor = 'green'; 
        p.EdgeColor = 'none';
        alpha(.4) % Make objects transparent.
        hold off
        camlight('headlight')
        lighting gouraud
        view(3)
        xlim([dom(1) dom(2)])
        ylim([dom(3) dom(4)])
        zlim([dom(5) dom(6)])
        legend(sprintf('%3.2f', isoval1), sprintf('%3.2f', isoval2));
        axis tight
        if ( ~holdState )
            hold off
        end
        if ( nargout > 0 )
            varargout = {p};
        end
    
    elseif ( numel(isovals)==3 ) % Levels are already given but colors and style are not.
        isoval1 = isovals(1);
        isoval2 = isovals(2); 
        isoval3 = isovals(3);
        p = patch(isosurface(xx, yy, zz, v, isoval1));
        p.FaceColor = 'red'; 
        p.EdgeColor = 'none';
        hold on
        p = patch(isosurface(xx, yy, zz, v, isoval2));
        p.FaceColor = 'green'; 
        p.EdgeColor = 'none';
        p = patch(isosurface(xx, yy, zz, v, isoval3));
        p.FaceColor = 'blue'; 
        p.EdgeColor = 'none';
        alpha(.4) % Make objects transparent.
        hold off; 
        camlight('headlight')
        lighting gouraud
        view(3)
        xlim([dom(1) dom(2)])
        ylim([dom(3) dom(4)])
        zlim([dom(5) dom(6)])
        
        legend(sprintf('%3.2f', isoval1), sprintf('%3.2f', isoval2), ...
            sprintf('%3.2f', isoval3));
        axis tight
        if ( ~holdState )
            hold off
        end
        if ( nargout > 0 )
            varargout = {p};
        end
        
    end
    
elseif ( nargin==3 ) % Levels, colors and/or style are specified.
        cc = regexp( varargin{2}, '[bgrcmykw]', 'match' );       % color        
        if ( isempty(cc) ) 
            cc{1}= 'g';
        end
    
    if ( numel(varargin(1))==1 ) % Levels
        if iscell(varargin(1))
            isoval1 = cell2mat(varargin(1));
        else
            isoval1 = varargin(1);
        end
    end
    p = patch(isosurface(xx, yy, zz, v, isoval1));
    p.FaceColor = cc{1}; 
    p.EdgeColor = 'none';
    camlight('headlight')
    lighting gouraud
    view(3)
    xlim([dom(1) dom(2)])
    ylim([dom(3) dom(4)])
    zlim([dom(5) dom(6)])
    axis tight
    if ( ~holdState )
        hold off
    end
     if ( nargout > 0 )
         varargout = {p};
     end
    
end

end % End of function


function runIsosurface3GUI(f)

h = instantiateIsosurface3();
handles = guihandles(h);
    
dom = f.domain;
numpts = 51;
[xx, yy, zz] = meshgrid(linspace(dom(1), dom(2), numpts), ...
    linspace(dom(3), dom(4), numpts), linspace(dom(5), dom(6), numpts));
v = feval(f, xx, yy, zz);
if ( ~isreal(v) )
    v = abs(v);
end
fMin = min(v(:)); 
fMax = max(v(:)); 
isoVal = (fMin + fMax)/2;

set(handles.isosurfaceSlider, 'Min', fMin);
set(handles.isosurfaceSlider, 'Max', fMax);
set(handles.isosurfaceSlider, 'Value', isoVal);

nSteps = 15; % number of steps allowed by the slider
set(handles.isosurfaceSlider, 'SliderStep', [1/nSteps, 1 ]);

% Plot the isosurface
p = patch(isosurface(xx, yy, zz, v, isoVal));

%p = patch(isosurface(x,y,z,v,-3));
%isonormals(x,y,z,v,p)
p.FaceColor = 'red';
p.EdgeColor = 'none';

camlight 
lighting gouraud

% Put the current value of the slider on the GUI
set(handles.printedIsoVal, 'String', num2str(isoVal));

view(3)
xlim([dom(1) dom(2)])
ylim([dom(3) dom(4)])
zlim([dom(5) dom(6)])

% Choose default command line output for isosurface
handles.xx = xx;
handles.yy = yy;
handles.zz = zz;
handles.v = v;
handles.isosurfaceSlice = isoVal;
handles.dom = dom;

% Update handles structure
guidata(h, handles);
handles.output = handles.isosurfaceSlider;

end


function h = instantiateIsosurface3()

% Load up the GUI from the *.fig file.
%h = openfig('/isosurface.fig', 'invisible');
% The following is to be used when this goes to the main Chebfun repo:
% [chebfunroot '@chebfun3/isosurface.fig']
installDir = chebfunroot();
h = openfig( [installDir '/@chebfun3/isosurface.fig'], 'invisible');

% Do any required initialization of the handle graphics objects.
G = get(h, 'Children');
for (i = 1:1:length(G))
    if ( isa(G(i), 'matlab.ui.control.UIControl') )
        % Adjust the background colors of the sliders.
        if ( strcmp(G(i).Style, 'slider') )
            if ( isequal(get(G(i), 'BackgroundColor'), ...
                    get(0, 'defaultUicontrolBackgroundColor')) )
                set(G(i), 'BackgroundColor', [.9 .9 .9]);
            end
        end
        
        % Register callbacks.
        switch ( G(i).Tag )
            case 'isosurfaceSlider'
                G(i).Callback = @(hObj, data) ...
                    isosurfaceSlider_Callback(hObj, data, guidata(hObj));
        end
    end
end

% Add a toolbar to the GUI.
set(h,'toolbar','figure');

% Store handles to GUI objects so that the callbacks can access them. 
guidata(h, guihandles(h));

% Make the GUI window "visible" to the rest of the handle graphics
% system so that things like gcf(), gca(), etc. work properly.
set(h, 'HandleVisibility', 'on');

% Draw the GUI.
set(h, 'Visible', 'on');
end


% --- Executes on zSlider movement.
function isosurfaceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to isosurfaceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

isoVal = get(hObject, 'Value'); %returns position of slider
dom = handles.dom;

% Clear the old plot
cla(handles.axes1);

p = patch(isosurface(handles.xx, handles.yy, handles.zz, handles.v, isoVal));
p.FaceColor = 'red';
p.EdgeColor = 'none';

camlight 
lighting gouraud


% Put the current value of the slider on the GUI
set(handles.printedIsoVal, 'String', num2str(isoVal));
xlim([dom(1) dom(2)])
ylim([dom(3) dom(4)])
zlim([dom(5) dom(6)])
handles.output = hObject;

end