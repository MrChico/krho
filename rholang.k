// Experimenting with implementing rholang in K, to learn more about both frameworks
// Learned so far;
//
// Actually, looks like syntax-sorts _can_ be mutually inductive.
//
// It appears that the current version of K cannot handle binding constructs with more than two args
// therefore, instead of writing `"for (" Id "<-" Name ")" Proc`, as one might like, we first bind Id in Proc, and then make it into a proc waiting on input
//
// TODO: allow for multiple bindings in "new" and contract

require "substitution.k"

module RHOLANG-SYNTAX
   imports SUBSTITUTION
   syntax Name ::= Id
   	      | Int
	      | Bool
	      | String
	      | "@" Proc
	      
   syntax BoundProc ::= Id "in" Proc		[binder] //Id is bound in Proc
   
   syntax In ::= Name "?" BoundProc		//Listening on Name

   syntax In ::= "for" "(" Id "<-" Name ")" Proc
   //Syntactic sugar; will be rewritten, see below
//   	     | "contract" Name "(" List{Id, ","} ")"
   
   syntax Out ::= Name "(" Name ")"      	   			//Output

   syntax Proc ::= "0"
   	       | In
	       | Out
	       | "{" Proc "}"			[bracket] //Fix this
   syntax Procs ::= List{Proc, "|"}

   syntax KVariable ::= Name | Id

   //The "for" syntactic sugar
   rule for (X:Id <- Y:Name) P:Proc => Y ? (X in P)

   rule Y:Name ? (X:Id in P:Proc) | Y(Z:Name) => P[Z / X]
endmodule

module RHOLANG
   imports SUBSTITUTION
   imports RHOLANG-SYNTAX

   configuration <T>
      <ins>
	<in multiplicity="*"> . </in>
      </ins>
      <outs>
        <out multiplicity="*"> . </out>
      </outs>
      <k> $PGM:Procs </k>
   </T>

   //Empty processes are simply removed
   rule <k> 0:Proc | Ts:Procs => Ts </k>

   //Processes that are waiting on input are placed in the <ins> box
   rule <k> I:In | Ts:Procs => Ts </k>
   	<ins> Ins => (Ins <in> I</in>) </ins>

   //Processes that want to output are placed in the <outs> box
   rule <k> O:Out | Ts:Procs => Ts </k>
   	<outs> Outs => (<out> O </out> Outs) </outs>

 
   //Comm rule:
   rule <in> (Y:Name ? (X:Id in P:In)) => P[Z / X]  </in>
   	<out> Y(Z:Name) => . </out>

    rule <in> (Y:Name ? (X:Id in P:Out)) => P[Z / X]  </in>
   	<out> Y(Z:Name) => P[Z / X] </out>

endmodule