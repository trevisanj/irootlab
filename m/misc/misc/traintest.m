%> @file
%> @ingroup misc
%> @brief Runs a single train-test and returns the logged logs
%
%> @param logs Logs to record the outcome
%> @param blk Block expected to output an @re estimato dataset
%> @param ds_train Train dataset
%> @param ds_test Test dataset
%> @param postpr_test (optional) Post-processor block for ds_test
%> @param postpr_est (optional) Post-processor block for the estimation dataset, which is the output of <code>blk.use(ds_test)</code>
%> @return [logs, blk] [Recorded logs, trained block]
function [logs, blk] = traintest(logs, blk, ds_train, ds_test, postpr_test, postpr_est)

if nargin < 6 || isempty(postpr_est)
    postpr_est = decider();
end;

if nargin < 5
    postpr_test = [];
end;

blk = blk.boot();
blk = blk.train(ds_train);
est = blk.use(ds_test);

if ~isempty(postpr_est)
    postpr_est = postpr_est.boot();
    est = postpr_est.use(est);
end;


if ~isempty(postpr_test)
    postpr_test = postpr_test.boot();
    ds_test = postpr_test.use(ds_test);
end;

pars = struct('est', {est}, 'ds_test', {ds_test}, 'clssr', {blk});
if iscell(logs)
    for il = 1:numel(logs)
        logs{il} = logs{il}.record(pars);
    end;
else
    logs = logs.record(pars);
end;
