%>@ingroup datasettools
%>@file
%>@brief PCA pareto chart (number of PCs)x(% variance explained)

%> @param data Dataset
%> @param no_pcs Number of "Principal Components"
function data_draw_pca_pareto(data, no_pcs)

% data = data_eliminate_var0(data, 1e-10);

X = data.X;

var_total = sum(var(X));


f = fcon_pca();
f.flag_rotate_factors = 0;
f.no_factors = no_pcs;

f = f.boot();
f = f.train(data);
data_pca = f.use(data);


vars = var(data_pca.X)/var_total*100;
figure;
plot(1:no_pcs, integrate(vars), 'k', 'LineWidth', 2);
hold on;
bar(1:no_pcs, vars);
set(gca, 'XLim', [0, no_pcs+1]);
set(gca, 'XTick', 1:no_pcs);
title('PCA pareto chart');
xlabel('PC');
ylabel('% variance explained');
format_frank();
% Copyright 2010 Julio Trevisan, Plamen P. Angelov & Francis L. Martin.
% e-mailing author: juliotrevisan@gmail.com
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% A copy of the GNU General Public License is shipped along with this
% program (filename: "COPYING").  For an online version of the license,
% see <http://www.gnu.org/licenses/>.
