function [saisir] = selectrow(saisir1,index)
%selectrow 	    	- creates a new data matrix with the selected rows
% usage: [X1]= selectrow(X,index) 
% the resulting file correspond to the selected rows
% index is a vector of indices (integer) or of booleans
saisir.d=saisir1.d(index,:);
saisir.i=saisir1.i(index,:);
saisir.v=saisir1.v;
