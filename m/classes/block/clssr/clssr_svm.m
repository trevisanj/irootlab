%> @brief Support Vector Machine Classifier using LibSVM
%>
%> Uses the famous LibSVM by Chih-Chung Chang and Chih-Jen Lin [1].
%>
%> For documentation on @c c and @c gamma, see [1].
%>
%> Also, type "svmtrain" at MATLAB's command window to see possible options for the kernel types. However, this binding is not fully
%> implemented yet.
%>
%> The possible kernels are shown below
%>
%> @arg 0 -- linear: u'*v
%> @arg 1 -- polynomial: (gamma*u'*v + coef0)^degree
%> @arg 2 -- radial basis function: exp(-gamma*|u-v|^2)
%> @arg 3 -- sigmoid: tanh(gamma*u'*v + coef0)
%> @arg 4 -- precomputed kernel (kernel values in training_instance_matrix)
%>
%>
%> @sa uip_clssr_svm.m, svmtrain()
%>
%> <h3>References:</3>
%> [1] http://www.csie.ntu.edu.tw/~cjlin/libsvm/
classdef clssr_svm < clssr
    properties
        %> =2 (radial basis function, or "Gaussian")
        kernel = 2;
        %> Cost parameter "C"
        c = 4;
        %> For radial basis, 
        gamma = 1;
        %> For polynomial kernel
        degree = 3;
        %> =0.001 . "tolerance of termination"
        epsilon = 0.001;
        %> Coef0 for the sigmoid & polynomial kernel
        coef0 = 0;
        %> =1. LibSVM's "shrinking"
        flag_shrink = 1;
        %> Whether to weight the observations (for unbalanced classes)
        flag_weighted = 0;
        %> weight exponent. If @ref flag_weighted is true, weights will be powered by this exponent before weight normalization
        weightexp = 1;
        %> =100. cache size in MB
        cachesize = 100;
    end;
    
    properties(SetAccess=private)
        no_svs = 0;
        svm;
        
        FLAG_B = 0;
    end;


    methods
        function o = clssr_svm(o)
            o.classtitle = 'Support Vector Machine';
            o.short = 'SVM';
        end;
    end;
    
    methods(Access=protected)
        
        function o = do_train(o, data)
            o.classlabels = data.classlabels;

            s = sprintf('-m %d -e %g -c %g -b %d -h %d -e 1e-2 ', o.cachesize, o.epsilon, o.c, o.FLAG_B, o.flag_shrink);
            
            switch o.kernel
                case 0
                    s = cat(2, s, '-t 0');
                case 1 % Polynomial
                    s = cat(2, s, sprintf('-t 1 -d %d -r %g', o.degree, o.coef0));
                case 2 % Radial basis Gaussian
                    s = cat(2, s, sprintf('-t 2 -g %g', o.gamma));
                case 3 % Sigmoid
                    s = cat(2, s, sprintf('-t 3 -g %g -r %g', o.gamma, o.coef0));
                case 4 % Sigmoid
                    irerror('Pre-computed kernel not supported!');
            end;
                
            if o.flag_weighted
                % Calculates weights for the classes
                w = [0:data.nc-1; data.get_weights(o.weightexp)];
                s = [s ' ' sprintf('-w%d %g ', w)];
            end;

            tic;
            o.svm = svmtrain(data.classes, data.X, s);
%             try
                o.no_svs = o.svm.totalSV;
%             catch ME
%                 disp('ooooooooooooooooooooooooooooooo');
%             end;
            o.time_train = toc;
        end;
        
        
        
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);
            
            if isempty(data.classes)
                data.classes = zeros(data.no, 1);
            end;

            % Accuracy will not be correct because there may be class shifts in both
            % the training and testing datasets.
            tic();
            [predict_label, accuracy, dec_values] = svmpredict(data.classes, data.X, o.svm, sprintf('-b %d', o.FLAG_B));
%             [predict_label, accuracy, dec_values] = svmpredict(data.classes, data.X, o.svm, '-b 0');
            o.time_use = toc();

%             est.classes = predict_label;
            if o.FLAG_B
                est.X = dec_values;
            else
                est.X = classes2boolean(predict_label);
            end;
        end;
    end;
end