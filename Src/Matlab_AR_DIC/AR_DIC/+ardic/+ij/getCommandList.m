function keys = getCommandList(options)
%
%   keys = ardic.ij.getCommandList(*options)
%
%   Output
%   ------
%   keys - string array
%       Names of the commands
%       Note this spans across all menu options so it
%       is a bit messy. Not sure if we can filter
%       at the higher level
%
%   Optional Inputs
%   ---------------
%   filter_string
%
%   Example
%   --------
%   keys = ardic.ij.getCommandList(filter_string='PIV')

arguments
    %NYI
    options.filter_string = '';
end

import ij.*

% Get command list
commands = ij.Menus.getCommands();

% Convert to MATLAB-friendly format
keys = commands.keySet().toArray();

keys = string(keys);

if ~isempty(options.filter_string)
    mask = contains(keys,options.filter_string);
    keys = keys(mask);
end



end