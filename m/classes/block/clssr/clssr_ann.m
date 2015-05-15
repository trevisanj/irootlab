%> @brief Neural Network Classifier. This is a wrapper to MATLAB's Neural Networks Toolbox
%>
%> Check MATLAB's NN toolbox documentation on net.trainParam
%>
%> This is by default tuned to finished trained mostly when the net overfits:
%> @arg High number of epochs
%> @arg goal is zero (will only stop according to this criterion if reaches 100% classification)
%> @arg min_grad is very small as well (1e-5)
%>
%> Input weights are initialized to 'midpoint', and layer weights are initialized to zero. This way, the classifier will be deterministic
%> (the default MATLAB "initnw" sounds nice but has randomness in it)
%>
%> @sa uip_clssr_ann.m
classdef clssr_ann < clssr
    properties
        %> whether classes must be converter into multiple-output boolean targets.
        flag_class2mo = 1;
        %> = [1]. Number of neurons in each hidden layer.
        hiddens = [1];

        % Learning parameters. Names match the ones in net.trainParam
        
        %> =0. Stands for the goal MSE (Mean Squared Error). Training stops when achieving this error. We don't know what to expect, so it is fair to
        %> expect 0 error (100 classification).
        goal = 0;
        %> = 1000
        epochs = 1000;
        %> = 10.
        show = 10;
        %> = 0.05.
        lr = 0.05;
        %> = 15 Maximum number of validation increases
        max_fail = 10;
        %> =0.
        flag_show_window = 0;
        %> Whether to weight the observations (for unbalanced classes)
        flag_weighted = 0;
        %> =1e-5. Minimum gradient.
        min_grad = 1e-5;
    end;
    
    properties(SetAccess=protected)
        net;
    end;

    methods
        function o = clssr_ann(o)
            o.classtitle = 'Artificial Neural Network';
            o.short = 'ANN';
        end;
    end;
    
    methods(Access=protected)
        
        function o = do_boot(o)
        end;
        
        

        % TODO actually this could even be multiple-trainable
        function o = do_train(o, data)
            o.classlabels = data.classlabels;
           
            tic;

            % TODO I pasted from the boot procedure an dI don't know it this is working, long time not using NN

            targets = classes2boolean(o.get_classes(data), o.no_outputs)';

            o.net = newpr(data.X', targets, o.hiddens);

            o.net.trainFcn = 'trainlm';
            
            o.net.trainParam.goal = o.goal;
            o.net.trainParam.epochs = o.epochs;
            o.net.trainParam.show = o.show;
            o.net.trainParam.lr = o.lr;
            o.net.trainParam.max_fail = o.max_fail;
            o.net.trainParam.showWindow = o.flag_show_window; % gets rid of this annoying GUI, TODO however not quite working
            
            
            
            


            o.net.initFcn = 'initlay'; % (net.initParam automatically becomes initlay's default parameters.)
            for i = 1:numel(o.net.layers)
                o.net.layers{i}.initFcn = 'initwb';
            end;
            for i = 1:size(o.net.inputWeights, 1)
                for j = 1:size(o.net.inputWeights, 2)
                    if ~isempty(o.net.inputWeights{i, j})
                        o.net.inputWeights{i, j}.initFcn = 'midpoint';
                    end;
                end;
            end;
            
            
            % These instructions of how to use midpoint are from MATLAB's reference to the midpoint function.
            % However, this gave errors and I opted for initializing the layer weights to zero
            
%             for i = 1:size(o.net.layerWeights, 1)
%                 for j = 1:size(o.net.layerWeights, 2)
%                     if ~isempty(o.net.layerWeights{i, j})
%                         o.net.layerWeights{i, j}.initFcn = 'midpoint';
%                     end;
%                 end;
%             end;
            
            
            
            
            o.net = init(o.net);
            
            for i = 1:size(o.net.LW, 1)
                for j = 1:size(o.net.LW, 1)
                    z = o.net.LW{i, j};
                    if ~isempty(z)
                        o.net.LW{i, j} = zeros(size(z));
                    end;
                end;
            end;
            
            
            
            
            


            % % Changes the way the data is split
            % o.net.divideFcn = 'divideind';
            % o.net.divideParam.trainInd = 1:no_obs_train;
            % o.net.divideParam.valInd = (no_obs_train+1):no_obs_total;
            % o.net.divideParam.testInd = (no_obs_train+1):no_obs_total;


            if ~o.flag_weighted
                [o.net, tr, output, error] = train(o.net, data.X', targets);
            else
                ww = data.get_weights(); % weights per class
                weights = zeros(1, data.no); % weights per observation

                for i = 1:data.nc
                    weights(data.classes == i-1) = ww(i);
                end;
                
                
% train(ftdnn_net,p,t,Pi,Ai,ew1);
                [o.net, tr, output, error] = train(o.net, data.X', targets, {}, {}, weights);
%                 [o.net, tr, output, error] = train(o.net, data.X', targets, [], []); 
            end;
                
            o.time_train = toc;
        end;
        
        
        
        function est = do_use(o, data)
            est = estimato();
            est.classlabels = o.classlabels;
            est = est.copy_from_data(data);

            tic();
            Y = sim(o.net, data.X')';           
            
            % TODO SoftMax!!!!!!!!11
            est.X = Y;
            
            
            o.time_use = toc();
        end;
    end;
end