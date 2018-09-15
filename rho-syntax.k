require "substitution.k"

module RHO-SYNTAX
imports SUBSTITUTION
imports DOMAINS-SYNTAX

// -------------
//   Processes
// -------------

// Processes
syntax Proc ::=
              // Ground terms
                Ground
              // Expressions
              | Exp
              // Process variables
              | ProcId
              // The empty process
              | "Nil"
              // Listen
              | "for" "(" NamePats "<-" Name ")" "{" Proc "}" [binder]
              // Persistent listen
              | "for" "(" NamePats "<=" Name ")" "{" Proc "}" [binder]
              // Contract **needs to be given an alias which binds**
              | "contract" Name "(" NamePats ")" "=" "{" Proc "}"
              // Send
              | Name "!" Send
              // Persistent send
              | Name "!!" Send
              // Evaluate
              | "*" Name
              // Match
              | "match" Proc "{" MatchCases "}"
              // If ... then ...
              | "if" "(" Bool ")" Proc [strict(1)]
              // If ... then ... else ...
              | "if" "(" Bool ")" Proc "else" Proc [strict(1)]
              // New
              | "new" ProcIds "in" "{" Proc "}" [binder]
              // Parallel
              | Proc "|" Proc [left]
              // Bracket
              | "{" Proc "}" [bracket]

// KResult for processes with "strict" arguments
syntax KResult ::= Bool

// Send
syntax Send  ::=
                "(" Proc ")"
              | RhoTuple

// Process variables
syntax ProcVar ::=
                ProcWildcard
              | ProcId

syntax ProcWildcard ::= "_"
syntax ProcId   ::= Id
syntax ProcIds  ::= List{ ProcId, "," }
syntax ProcVars ::= List{ ProcVar, ","}

// Ground processes
syntax Ground ::=
                Int
              | Bool
              | String
              // | Uri
              | Collection
              // The unforgeable processes used in the "new" process
              | "unforgeable(" Int ")"

// Collections
syntax Collection ::=
                RhoList
              | RhoSet
              | RhoTuple
              | RhoMap

syntax RhoList  ::= "[" Procs "]"
syntax RhoSet   ::= "Set" "(" Procs ")"
syntax RhoTuple ::=
              // Single tuple
                "(" Proc ",)"
              // Multiple tuple
              | "(" Proc "," Proc "," Procs ")"

syntax RhoMap   ::= "{" RhoKeyValuePairs "}"

syntax RhoKeyValuePairs ::= List{ RhoKeyValuePair, ","}
syntax RhoKeyValuePair  ::= Proc ":" Proc

// Expressions are anything that necessarily resolves to a single ground value
syntax Exp  ::=
                Ground
              // Arithmetic expressions
              | AExp


// Arithmetic expressions
syntax AExp ::=
                Int "*"  Int [strict]
              | Int "/"  Int [strict]
              // Remainders
              > Int "%%" Int [strict]
              | Int "+"  Int [strict]
              | Int "-"  Int [strict]
              // Plus plus
              > Int "++" Int [strict]
              // Minus minus
              | Int "--" Int [strict]

// KResult for "strict" arguments
syntax KResult ::= Int

// Booleans
syntax Bool ::=
                Proc "matches" Proc
              | Proc "==" Proc
              | Proc "!=" Proc


// -------------
//     Names
// -------------

// Names
syntax Name ::=
                "@" Proc
              | NameVar

// Name variables
syntax NameVar ::=
                NameWildcard
              | NameId

syntax NameWildcard ::= "_"
syntax NameId   ::= Id
syntax NameIds  ::= List{ NameId, "," }
syntax NameVars ::= List{ NameVar, ","}

// -------------
//    Both Names and Processes
// -------------

syntax Names ::= List{ Name, "," }
syntax Procs ::= List{ Proc, "," }


// -------------
//    Patterns
// -------------

// ---
// Process Patterns
// ---

syntax ProcPat ::=
            // A process pattern can be a standard process
              Proc
            // Incl a process wildcard
            | ProcVar
            // It can also be a process with the more general version of variables
            | "for" "(" NamePats "<-" NamePat ")" "{" ProcPat "}" [binder]
            // Persistent listen
            | "for" "(" NamePats "<=" NamePat ")" "{" ProcPat "}" [binder]
            // Contract **needs to be given an alias which binds**
            | "contract" NamePat "(" NamePats ")" "=" "{" ProcPat "}"
            // Send
            | NamePat "!" "(" ProcPats ")"
            // Persistent send
            | NamePat "!!" "(" ProcPats ")"
            // Evaluate
            | "*" NamePat
            // Match
            | "match" ProcPat "{" MatchCasesPat "}"
            // If ... then ...
            | "if" "(" Bool ")" ProcPat [strict(1)]
            // If ... then ... else ...
            | "if" "(" Bool ")" ProcPat "else" ProcPat [strict(1)]
            // New
            | "new" ProcIds "in" "{" ProcPat "}" [binder]
            // Parallel
            | ProcPat "|" ProcPat [left]
            // Bracket
            | "{" ProcPat "}" [bracket]
            // Can also include logical connectives
            // logical negation
            | "~" ProcPat
            // logical "and"
            > ProcPat "/\\" ProcPat [left]
            // logical "or"
            > ProcPat "\\/" ProcPat [left]


// ---
// Name Patterns
// ---

syntax NamePat ::=
            // Either a variable (incl. wildcards)
              NameVar
            // Or it could just be a name
            | Name
            // It can also be a quoted process pattern
            | "@" ProcPat

// ---
// Both Name and Process Patterns
// ---

syntax Pat ::=
            // A name pattern
              NamePat
            // A process pattern
            | ProcPat

syntax NamePats ::= List{ NamePat, "," }
            | Names
            | NameVars
syntax ProcPats ::= List{ ProcPat, "," }
            | Procs
            | ProcVars

// -------------
//    For K
// -------------

syntax KVariable ::= Id
syntax KResult   ::= Bool | Int

// -------------
//    Some syntax for the "match" process
// -------------

// Syntax for the "match" process
syntax MatchCase  ::= ProcPat "=>" "{" Proc "}" [binder]
syntax MatchCases ::= List{MatchCase, " "}

// The same but for patterns
syntax MatchCasePat  ::= ProcPat "=>" "{" ProcPat "}" [binder]
            | MatchCase
syntax MatchCasesPat ::= List{MatchCasePat, " "}
            | MatchCases


endmodule
