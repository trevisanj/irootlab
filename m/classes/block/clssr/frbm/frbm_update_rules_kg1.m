%> @file
%> @brief 1-rule-per-class
%>
%> "11" means 1-to-1, referring to the fact that this rule updating procedure works with one rule per ruleset only
%>
%> This rule updating will probably work with any setup, no parameter restrictions.
%>
%> This one can be interesting for a number of reasons
%> @arg it is simple
%> @arg a Bayes classifier can be implemented (well, if the classes have the same number of points):
%> @verbatim
%>   p(class|x) = p(x|class)*p(class)/p(x). p(x) does not matter and p(class) is not part of the model, so the classes need to be balanced
%> @endverbatim
%>   Also I believe we need a TS0 here
%> @arg a linear classifier can be implemented if .flag_per_class is zero and we use TS1
%> @arg we don't need to be concerned about what to do with a new point. Basically, what this procedure does is:
%> If it is the first point, then a rule is added, otherwise the existing rule is supported
%> @arg This implements the classifier described by Plamen in his "A Simple Fuzzy Rule-based System through Vector
%> Membership and Kernel-based Granulation" (2010), section III.
function o = frbm_update_rules_kg1(o)


if o.rulesets(o.i_ruleset).no_rules == 0
    o = o.add_rule();
    
else
    o.index_closest = 1; %o.rulesets(i_ruleset).idxs(1); % this .idxs will always have only one element
    o.delta_z = o.z-o.rulesets(o.i_ruleset).rules(o.index_closest).focalpoint;
	o = o.support_rule();
end;
