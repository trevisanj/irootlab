%> @ingroup maths
%> @file
%> @brief Polynomial baseline correction
%>
%> <h3>References:</h3>
%> [1] Beier BD, Berger AJ. Method for automated background subtraction from Raman spectra containing known contaminants. 
%> The Analyst. 2009; 134(6):1198-202. Available at: http://www.ncbi.nlm.nih.gov/pubmed/19475148.
%
%> @param X [no][nf] matrix
%> @param order polynomial order
%> @param epsilon tolerance to stop iterations. If zero or no value given, will default to <code>sqrt(1/30*nf)</code>
%> @param Xcont [no_cont][nf] matrix containing contaminants to be eliminated
%> @return Corrected matrix
function X = bc_poly(X, order, epsilon, Xcont)

[no, nf] = size(X);

if ~exist('epsilon', 'var') || epsilon <= 0
    % epsilon will be compared to a vector norm. If we assume the error at all elements to have the same importance, it
    % the norm of the error will be something like sqrt(nf*error_i)
    % For the tolerance to be 1 when nf = 1500 (empirically found to work) the formula below is set.
    epsilon = sqrt(1/90*nf);
end;

flag_cont = exist('Xcont', 'var') && ~isempty(Xcont); % take contaminants into account?
if ~flag_cont
    Xcont = [];
    no_cont = 0;
end;

x = 1:nf; % x-values to be powered as columns of a design matrix

if flag_cont
    % If contaminants are present, mounts a design matrix containing powers
    % of x and the contaminants as different columns
    no_cont = size(Xcont, 1);
    M = zeros(nf, order+1+no_cont);
    M(:, no_cont) = Xcont';

end;
    
    for i = 1:order+1
        M(:, no_cont+i) = x'.^(i-1);
    end;
    MM = M'*M;
% end;


ipro = progress2_open('Polynomial baseline correction', [], 0, no);
for i = 1:no
    y = X(i, :);
    y_save = y;

    flag_first = 1;
    while 1
%         if ~flag_cont
%             % I no contaminant is present, uses MATLAB's polyfit rather
%             % than least-squares solution. I didn't check which is faster.
%             p = polyfit(x, y, order);
%             yp = polyval(p, x);
%         else
            % all-in-one least-squares solution and linear combination of the columns of M
            
            % (29/03/2011) Least-Squares solution is faster than polyfit()
            
            warning off; %#ok<*WNOFF>
            try
                yp = (M*(MM\(M'*y')))';
                warning on; %#ok<*WNON>
            catch ME
                warning on;
                rethrow(ME);
            end;
%         end;

        % y for next iteration will be a chopped-peak version of y
        y = min(y, yp);
        
        if ~flag_first
            if norm(y-y_previous) < epsilon
                break;
            end;
        else
            flag_first = 0;
        end;
        
        y_previous = y;     
    end;

   
    X(i, :) = y_save-yp;
    

    ipro = progress2_change(ipro, [], [], i);
end;
progress2_close(ipro);
