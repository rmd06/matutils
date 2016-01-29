function movepatch(h,d)
%MOVEIT   Move a graphical object in 2-D.
%   Move an object in 2-D. Modify this function to add more functionality
%   when e.g. the object is dropped. It is not perfect but could perhaps
%   inspire some people to do better stuff.
%
%   d - optional, 'x', 'y' or 'xy' (default) to constrain movement
%
%   % Example:
%   t = 0:2*pi/20:2*pi;
%   X = 3 + sin(t); Y = 2 + cos(t); Z = X*0;
%   h = patch(X,Y,Z,'g')
%   axis([-10 10 -10 10]);
%   fig.movepatch(h);
%
% Author: Anders Brun, anders@cb.uu.se
%
% Copyright (c) 2009, Anders Brun
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

if nargin < 2
   d = 'xy';
end

% Unpack gui object
gui = get(gcf,'UserData');

% Make a fresh figure window
set(h,'ButtonDownFcn',{@startmovit d});

% Store gui object
set(gcf,'UserData',gui);

function startmovit(src,evnt,d)
% Unpack gui object
gui = get(gcf,'UserData');

% Remove mouse pointer
set(gcf,'PointerShapeCData',nan(16,16));
set(gcf,'Pointer','custom');

% Set callbacks
gui.currenthandle = src;
thisfig = gcbf();
set(thisfig,'WindowButtonMotionFcn',{@movit d});
set(thisfig,'WindowButtonUpFcn',@stopmovit);

% Store starting point of the object
gui.startpoint = get(gca,'CurrentPoint');
set(gui.currenthandle,'UserData',{get(gui.currenthandle,'XData') get(gui.currenthandle,'YData')});

% Store gui object
set(gcf,'UserData',gui);

function movit(src,evnt,d)
% Unpack gui object
gui = get(gcf,'UserData');

try
   if isequal(gui.startpoint,[])
      return
   end
catch
end

% Do "smart" positioning of the object, relative to starting point...
pos = get(gca,'CurrentPoint')-gui.startpoint;
XYData = get(gui.currenthandle,'UserData');

if any(d=='x')
   set(gui.currenthandle,'XData',XYData{1} + pos(1,1));
end
if any(d=='y')
   set(gui.currenthandle,'YData',XYData{2} + pos(1,2));
end
drawnow;

% Store gui object
set(gcf,'UserData',gui);

function stopmovit(src,evnt)
% Clean up the evidence ...
thisfig = gcbf();
gui = get(gcf,'UserData');
set(gcf,'Pointer','arrow');
set(thisfig,'WindowButtonUpFcn','');
set(thisfig,'WindowButtonMotionFcn','');
drawnow;
set(gui.currenthandle,'UserData',[],'ButtonDownFcn',[]);
set(gcf,'UserData','stop');
%set(gcf,'UserData',[]);