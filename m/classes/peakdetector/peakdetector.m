%> @brief Peak Detector
%>
%> The algorithm is implemented in detect_peaks.m
%>
%> @sa detect_peaks.m
classdef peakdetector < irobj
    properties
        %> =0. Minimum vertical distance between peak and zero
        minaltitude = 0;
        %> =0. Minimum vertical distance between peak and closest trough
        minheight = 0;
        %> Minimum distance between peaks, expressed in number of points.
        mindist;
        %> Minimum distance between peaks, expressed in native units.
        mindist_units;
        %> =1. Whether minaltitude and minheight are expressed in percentage. If true, the actual minimum altitude and
        %> minimum height will be calculated as a percentage of max(abs(y)).
        flag_perc = 1;
        %> =Inf. Maximum number of peaks to be returned. If used, peak are returned in ranked order of height.
        no_max = Inf;
        %> =1. Whether absolute value of the signal should be used. If 0, negative parts of the signal are made into
        %> "lakes", i.e., replaced by zeroes
        flag_abs = 1;
    end;
        
    properties(SetAccess=protected)
        %> Horizontal spacing between points, expressed in native units.
        spacing;
        minalt;
        minhei;
        flag_booted = 0;
    end;
    
    methods
        function o = peakdetector(o)
            o.classtitle = 'Peak Detector';
            o.color = [170, 189, 193]/255;
        end;
        
        %> Detects peaks
        %>
        %> If the peak detector is going to be used many times, it is better to boot it first. Otherwise it will be internally booted
        %> every time it is used.
        %>
        %> The peak detector will be internally booted when:
        %> @arg @c x is not empty, or
        %> @arg @c the peak detector hasn't been booted before
        %>
        %> @param x x-axis values. If not empty, the peak detector will be internally booted.
        %> @param y curve to detect peaks from
        function idxs = use(o, x, y)
            y = y(:)';
            if ~o.flag_booted || ~isempty(x)
                if isempty(x)
                    x = 1:numel(y);
                end;
                x = x(:)';
                o = o.boot(x, y);
            end;
                       
            if ~isempty(o.mindist)
                mindist_ = o.mindist;
            else
                if ~isempty(o.mindist_units)
                    mindist_ = ceil(o.mindist_units/o.spacing);
                else
                    irerror('Minimum distance between points not specified: specify either mindist or mindist_units');
                end;
            end;

            if o.flag_abs
                y = abs(y);
            else
                y(y < 0) = 0;
            end;
            y(y == Inf) = realmax;
            
            idxs = detect_peaks(y, o.minalt, o.minhei, mindist_);
            
            if o.no_max > 0 && length(idxs) > o.no_max
                [dummy, idx] = sort(y(idxs), 'descend');
                idxs = idxs(idx(1:o.no_max));
            end;
        end;
    end;
    
    methods
        function o = boot(o, x, y)
            o.spacing = abs(x(2)-x(1));
            
            if o.flag_perc
                if o.minaltitude > 1 || o.minaltitude < 0
                    irerror('Invalid percentual minimum altitude!');
                end;
                if o.minheight > 1 || o.minheight < 0
                    irerror('Invalid percentual minimum height!');
                end;
                top = max(abs(y));
                top(top == Inf) = realmax;
                o.minalt = o.minaltitude*top;
                o.minhei = o.minheight*top;
            else
                o.minalt = o.minaltitude;
                o.minhei = o.minheight;
            end;
            
            o.flag_booted = 1;
        end;
    end;
end