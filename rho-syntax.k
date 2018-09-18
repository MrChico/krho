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
              | ProcVar
              // The empty process
              | "Nil"
              // Listen
              | "for" "(" Receipt ")" "{" Proc "}" [binder]
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

// Variables
syntax Wildcard ::= "_"
syntax Var      ::= Wildcard | Id
syntax Vars     ::=
                Var
              | Var "," Vars
              | Ids
syntax Ids      ::=
                Id
              | Id "," Ids

// Process variables
syntax ProcVar ::=
                ProcWildcard
              | ProcId

syntax ProcWildcard ::= Wildcard
syntax ProcId   ::= Id
syntax ProcIds  ::=
                ProcId
              | ProcId "," ProcIds
              | Ids
syntax ProcVars ::=
                ProcVar
              | ProcVar "," ProcVars
              | ProcIds
              | Vars

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
              | "(" Proc "," Proc ")"
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

// Booleans
syntax Bool ::=
                Proc "matches" Proc
              | Proc "==" Proc
              | Proc "!=" Proc

// Send
syntax Send  ::=
                "(" Proc ")"
              | RhoTuple

// Receipt
syntax Receipt ::=
                ReceiptLinear
              | ReceiptRepeated

// Linear receipts
syntax ReceiptLinear ::=
                LinearBinds

syntax LinearBinds ::=
                LinearBind
              | LinearBind ";" LinearBinds
syntax LinearBind  ::=
                NamePats "<-" Name

// Repeated receipts
syntax ReceiptRepeated ::=
                RepeatedBinds

syntax RepeatedBinds ::=
                RepeatedBind
              | RepeatedBind ";" RepeatedBinds
syntax RepeatedBind  ::=
                NamePats "<=" Name

// MatchCase
syntax MatchCase  ::= ProcPat "=>" "{" Proc "}" [binder]
syntax MatchCases ::=
                MatchCase
              | MatchCase MatchCases

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
              | Id

syntax NameWildcard ::= Wildcard
syntax NameId   ::= Id
syntax NameIds  ::=
                NameId
              | NameId "," NameIds
              | Ids
syntax NameVars ::=
                NameVar
              | NameVar "," NameVars
              | NameIds
              | Vars

// -------------
//    Both Names and Processes
// -------------

syntax Names ::=
                Name
              | Name "," Names
              | NameVars
syntax Procs ::=
                Proc
              | Proc "," Procs
              | ProcVars

// -------------
//    Patterns
// -------------

// Process Patterns
syntax ProcPat ::=
            // A process pattern can be a standard process
              Proc
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

// Name Patterns
syntax NamePat ::=
            // Or it could just be a name
              Name
            // It can also be a quoted process pattern
            | "@" ProcPat

// Both Name and Process Patterns
syntax Pat ::=
            // A name pattern
              NamePat
            // A process pattern
            | ProcPat

syntax NamePats ::=
                NamePat
              | NamePat "," NamePats
              | Names
syntax ProcPats ::=
                ProcPat
              | ProcPat "," ProcPats
              | Procs

// -------------
//    For K
// -------------

syntax KVariable ::= Id
syntax KResult   ::= Bool | Int


endmodule
