%> @brief REPeated Train-Test
%>
%> Different behaviuors and applications implemented in descendants.
%>
%> Typically, @c block_mold and @c log_mold will contain several elements and results will be 2D or 3D log matrices.
%>
%> @sa uip_reptt.m
classdef reptt < as
    properties
        %> Cell array. Blocks to be trained-tested.
        block_mold;
        %> Cell array. Molds for the recording.
        log_mold;
        %> (Optional) Block to post-process the test data. For example, a @ref grag_classes_first.
        postpr_test;
        %> Block to post-process the estimation issued by the classifier. Examples:
        %> @arg a @ref decider
        %> @arg a @block_cascade_base consisting of a @ref decider followed by a @ref grag_classes_vote
        postpr_est;
    end;
    
      
    properties %(SetAccess=protected)
        %> Mounted at "runtime"
        logs;
        %> Mounted at "runtime"
        blocks;
    end;
    

    methods
        function o = reptt()
            o.classtitle = 'Repeated Train-Test';
        end;
    end;

    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% These are tools to be used by descendant classes
    methods(Access=protected)
        %> Checks validity of post_processors and boots them.
        %>
        %> Please note that this will pass if either or both are empty.
        %>
        %> These is a tool to be used by descendant classes, as required.
        function o = boot_postpr(o)
            % Checks if postpr_est is ok; boots the post-processors
            
            % Just testing if I still need to worry about booting
            
            if ~isempty(o.postpr_est)
                o.postpr_est = o.postpr_est.boot();
%                 assert_decider(o.postpr_est);
            end;
            if ~isempty(o.postpr_test)
                o.postpr_test = o.postpr_test.boot();
            end;
        end;                
    end;
end
