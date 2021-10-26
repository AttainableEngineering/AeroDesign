function SecondsToTimeElapsed(sec)
% Convert and get output values
day = sec/86400;             % [days]
days = floor(day);                  % integer days
year = day/365;                     % [years]
years = floor(year);                % int years
hour = (day - days)*24;             % [hours]
hours = floor(hour);                % int hours
minute = (hour - hours)*60;         % [minues]
minutes = floor(minute);            % int minutes
seconds = (minute - minutes)*60;    % [seconds]
if years == 0 && days == 0
    fprintf("Time till arrival after burn: %g hours, %g minutes, %.4g seconds.\n", hours, minutes, seconds)
elseif years == 0
        fprintf("Time till arrival after burn: %g days, %g hours, %g minutes, %.4g seconds.\n", days, hours, minutes, seconds)
else
    fprintf("Time till arrival after burn: %g years, %g days, %g hours, %g minutes, %.4g seconds.\n", years, days, hours, minutes, seconds) 
end