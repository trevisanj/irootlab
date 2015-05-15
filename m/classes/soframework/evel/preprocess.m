%> Applies default pre-processing to dataset
function ds  = preprocess(ds)
blk = get_defaultpp();
blk = blk.boot();
blk = blk.train(ds);
ds = blk.use(ds);
