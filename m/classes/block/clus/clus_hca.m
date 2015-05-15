%> @brief Hierarchical Clustering
%>
%> Clustering generates another dataset whose variables will be cluster indexes. Each variable is a different scheme
%> corresponding to a split considering a different number of clusters. Once the distance matrix is built and the
%> dendrogram is derived, it is easy to generate different dendrogram cuts.
%>
%> @sa uip_clus_hca.m, pdist, linkage (MATLAB functions)
classdef clus_hca < clus
    properties
        %> Minimum number of clusters
        nc_min = 2;
        %> Maximum number of clusters
        nc_max = 100;
        %> ='euclidean'. Distance type. See help for @c pdist() for possible types.
        distancetype = 'euclidean';
        %> ='ward'. Linkage type. Default is set to the famous "Ward". See help for @c linkage() for possible types.
        linkagetype = 'ward';
    end;
    
    methods
        function o = clus_hca(o)
            o.classtitle = 'Hierarchical Cluster Analysis';
            o.short = 'HCA';
        end;
    end;
    
    methods(Access=protected)
        function dout = do_use(o, data)
            
            
            % 1) Distance matrix
            ipro = progress2_open('HCA - distance matrix ...', [], 0, 2);
            irverbose(sprintf('Starting calculation of the distance matrix with %d observations...', data.no));
            t = tic();
            
            b_obsidxs = data.classes >= 0;
            no_new = sum(b_obsidxs);
            
            Y = pdist(single(data.X(b_obsidxs, :)), o.distancetype);
            irverbose(sprintf('...finished (took %g seconds)', toc(t)));
            
            
            % 2) Linkage
            ipro = progress2_change(ipro, 'HCA - linkage ...', [], 1);
            Z = linkage(Y, o.linkagetype);

            
            % 2.5) Organizing into dataset
            Xnew = ones(data.no, o.nc_max-o.nc_min+1)*-3; % default value is -3: "refuse-to-cluster"
            for i = o.nc_min:o.nc_max
                Xnew(b_obsidxs, i-o.nc_min+1) = cluster(Z, 'MaxClust', i)-1;
            end;

            dout = irdata_clus();
            dout = dout.import_from_struct(data);
            
            dout.X = double(Xnew);
            dout.fea_x = o.nc_min:o.nc_max;
            dout.title = [dout.title, ' - HCA'];
            dout.xname = 'Number of clusters';
            dout.xunit = '';
            dout.yname = 'Cluster number';
            dout.yunit = '';
            
            ipro = progress2_change(ipro, 'HCA - finished!', [], 2);
            progress2_close(ipro);
        end;
    end;
end