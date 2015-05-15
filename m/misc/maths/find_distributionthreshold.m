%> @ingroup maths
%> @file
%> @brief Originally created for Nik's study [1]
%>
%> [1] Purandare, N. C., Patel, I. I., Trevisan, J., Bolger, N., Kelehan, R., von Bünau, G., ... & Martin, F. L. (2013).
%>     Biospectroscopy insights into the multi-stage process of cervical cancer development: probing for spectral biomarkers
%>     in cytology to distinguish grades. Analyst.
%
%> @param ds a two-class, 1-feature dataset
%> @return threshold
function threshold = find_distributionthreshold(ds)

NP = 400;

pieces = data_split_classes(ds);

% If first class has greater mean, swaps
if mean(pieces(1).X(:, 1)) > mean(pieces(2).X(:, 1))
    pieces = pieces([2, 1]);
end;

X1 = pieces(1).X(:, 1)';
X2 = pieces(2).X(:, 1)';

% "class probabilities"
p1 = pieces(1).no;
p2 = pieces(2).no;

xmin = min([X1 X2]);
xmax = max([X1 X2]);



xinter = linspace(xmin, xmax, NP);

[x1, y1] = distribution(pieces(1).X, NP, [xmin, xmax]);
[x2, y2] = distribution(pieces(2).X, NP, [xmin, xmax]);

yinter1 = spline(x1, y1, xinter)*p1;
yinter2 = spline(x2, y2, xinter)*p2;

if 1
    figure;
    plot(xinter, yinter1);
    hold on;
    plot(xinter, yinter2, 'k');
    disp('hello from find_distribution threshold');
end;

% Finds top of first mountain to start from there
[top1_value, top1_index] = max(yinter1);

threshold = [];
for i = top1_index:NP
    if yinter1(i) < yinter2(i)
        if i == top1_index
%             irerror('Mountain with lowest average is completely engulfed!');
            irwarning('Mountain with lowest average is completely engulfed!');
            threshold = (xmax+xmin)/2;
            break;
        else
            % Done!
            threshold = xinter(i-1);
            break;
        end;
    end;
end;
if isempty(threshold)
%     irerror('Mountain with highest average is completely engulfed!');
    irwarning('Mountain with highest average is completely engulfed!');
    threshold = (xmax+xmin)/2;
end;
