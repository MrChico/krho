//Experimenting with implementing rholang in K, to learn more about both frameworks
//Learned so far;
//
//Grammars defined in k cannot be mutually inductive, so we cannot
//the higher order nature of rholang in the following way
// Proc ::= ... | deref Name
// Name ::= @Proc
// there is probably a way around this though, building up more nuanced layers
// of hierchical expressions
//
// K can only have binder constructs be of arity 2. See comment
//
// When it comes to interpreting the comms rule in the syntax we would like to utilize
// some of the nice abstraction we have in K. Therefore, it probably makes sense to have
// concurrent processes giving rise to Bags in the configuration. One needs to take into
// account which variables are bound in which Bag though.
// The current implementation does not go this route.
require "substitution.k"

module RHOLANG
   imports SUBSTITUTION
   syntax Name ::= Id
   syntax Proc ::=  "Nil"					//Base case
   	      | "{" Proc "}"			     [bracket]  //
      	      | "new" Id "in" Proc		     [binder]   //Binds name in the process
	      //It appears that the current version of K cannot handle binding constructs with more than two args
//therefore, instead of writing `"for (" Id "<-" Name ")" Proc`, as one might like, we do the following (hack)
	      | Name "." Proc	      	    	      	  	//Listening on name
	      | "for " Id "<-" Proc		     [binder]	//binds Id in name
 	      | Name "(" Name ")"      	   			//Output
  	      > Proc "|" Proc					//Parallel
   syntax KVariable ::= Id


  rule for X:Id <- Y:Name . P:Proc | Y:Name(Z:Name) => P[Z / X]
endmodule