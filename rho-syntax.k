require "substitution.k"

module RHO-SYNTAX
imports SUBSTITUTION
imports DOMAINS



// Processes are concrete or variables
syntax Proc ::= ProcConcrete
              | Id

// Concrete processes are built up from the following constructors:
syntax ProcConcrete ::=
              // Ground terms, including the empty process and expressions
                Ground
              // Listen
              | "for" "(" Names "<-" Name ")" "{" ProcConcrete "}" [binder(1 -> 3)]
              // Persistent listen
              | "for" "(" Names "<=" Name ")" "{" ProcConcrete "}" [binder(1 -> 3)]
              | "contract" Name "(" Names ")" "=" "{" ProcConcrete "}"
              // Send
              | Name "!" "(" Procs ")"
              // Persistent send
              | Name "!!" "(" Procs ")"
              // Evaluate
              | "*" Name
              // New
              | "new" Names "in" "{" ProcConcrete "}" [binder]
              // Match
//              | "match" ProcOrName "{" MatchCases "}"
              // Parallel
              | ProcConcrete "|" ProcConcrete [left]
              // Bracket
              | "{" ProcConcrete "}" [bracket]

// Grouping "Nil" and Exp is useful, as they behave the same on the top-level
// but we should note here that they are NOT structurally equivalent, nor are
// they semantically equivalent in a general sense.
syntax Ground ::= "Nil"
              | Exp

syntax Exp  ::= Int
              | Bool
              | String

syntax KVariable ::= Id

// The general idea of a name can be a (bound) variable. It can also
// contain logical connectives. We need to distinguish between non-variable
// terms, with no logical connectives, etc and those that are or have them.
syntax Name ::= "@" Proc
              | Id
              // logical "and"
              | Name "/\\" Name [left]
              // logical "or"
              > Name "\\/" Name [left]

// Naïve non-empty list contructions for names and processes
syntax Names ::= Name |
                 Name "," Names [right]
syntax Procs ::= Proc |
                 Proc "," Procs [right]

syntax KResult ::= Int
              | String //StringlessMatchFormSyntax
              | Bool
              | Id
              | ProcConcrete
endmodule
