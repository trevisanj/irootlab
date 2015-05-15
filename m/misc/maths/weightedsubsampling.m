%>@ingroup maths
%>@file
%>@brief Weighted subsampling
%>
%> Does so by integrating the weights, then approximate "soft" (closest match) binary search. Selected items are marked and garbage collection takes place once in a while, then integrates again etc.
%
%> @param no_sel Number of observations to select
%> @param weights Observation weights
function idxs = weightedsubsampling(no_sel, weights)

no_weights = numel(weights);

% These variables will have items removed at "garbage collection"
weirem = weights; % Remaining weights
map = 1:no_weights; % Original indexes or remaining weights
weiyi = cumsum(weirem); % Accumulated sum of remaining weights
flag_gone = zeros(1, no_weights);


maiyi = weiyi(end); % End of cumulative sum of weights to scale random number generation
wei_gone = 0;
wei_gone_threshold = maiyi/2;


% it_no_gone_threshold = max(100, numel(weiyi)/3);

idxs = zeros(1, no_sel);

i = 1;
% it_no_gone = 0;
while 1
    ii = bsearch(weiyi, rand()*maiyi, 1); % Monotonic inverse function lookup (finds x-value based on random y-value)
    
    if ~flag_gone(ii)
        idxs(i) = map(ii);
        i = i+1;
        if i > no_sel
            break;
        end;
        
        flag_gone(ii) = 1;
%         it_no_gone = it_no_gone+1;
        wei_gone = wei_gone+weights(map(ii));
        
        if wei_gone >= wei_gone_threshold %it_no_gone >= it_no_gone_threshold
            % Garbage collection is triggered when half the "total weight area" has been covered
            % "total weight area" is defined as the sum of all the weights
            weirem = weirem(~flag_gone);
            map = map(~flag_gone);
            weiyi = cumsum(weirem);
            flag_gone = zeros(1, numel(weiyi));

            maiyi = weiyi(end);
            wei_gone = 0;
            wei_gone_threshold = maiyi/2;
%             it_no_gone = 0;
%             it_no_gone_threshold = max(100, numel(weiyi)/3);
        end;
    end;
    
    
    
%     % Takes item out of the box
%     maiyi = maiyi-weights(map(ii));
%     weiyi(ii+1:end) = weiyi(ii+1:end)-weights(map(ii));
%     map(ii) = [];
%     weiyi(ii) = [];
%     
end;

