% Get MAC address
%
% from Javeer at http://undocumentedmatlab.com/blog/unique-computer-id/
function mac_add = mac

switch computer('arch')
   case {'maci','maci64'}
      [~,a]=system('ifconfig');
      c=strfind(a,'en0');if ~isempty(c),a=a(c:end);end
      c=strfind(a,'en1');if ~isempty(c),a=a(1:c-1);end
      % find the mac address
      b=strfind(a,'ether');
      mac_add=a(1,b(1)+6:b(1)+22);
   case {'win32','win64'}
      [~,a]=system('getmac');b=strfind(a,'=');
      mac_add=a(b(end):b(end)+19);
   case {'glnx86','glnxa64'}
      [~,a]=system('ifconfig');b=strfind(a,'Ether');
      mac_add=a(1,b(1)+17:b(1)+33);
   otherwise,mac_add=[];
end