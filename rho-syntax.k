require "substitution.k"

module RHO-SYNTAX
imports SUBSTITUTION
imports DOMAINS-SYNTAX

// -------------
//   Processes
// -------------

// Processes
syntax Proc ::=
              // Bracket
                "{" Proc "}" [bracket]
              // Ground terms
              | Ground
              // Collection
              | Collection
              // Process variables
              | ProcVar
              // The empty process
              | "Nil"
              // Variable reference
              > VarRef
              // Evaluate
              > "*" Name
              // Method
              > Proc "." Method "(" Procs ")"
              // Arithmetic expressions
              > AExp
              // Boolean expressions
              > Bool
              // Send
              > Name Send
              // Contract **needs to be given an alias which binds**
              > "contract" Name "(" NamePats ")" "=" "{" Proc "}"
              // Listen
              | "for" "(" Receipt ")" "{" Proc "}" [binder]
              // Select
              | "select" "{" Branches "}"
              // Match
              | "match" Proc "{" MatchCases "}"
              // Bundle
              | Bundle "{" Proc "}"
              // If ... then ...
              > "if" "(" Bool ")" Proc [strict(1)]
              // If ... then ... else ...
              | "if" "(" Bool ")" Proc "else" Proc [strict(1)]
              // New
              | "new" NameDeclarations "in" "{" Proc "}" [binder]
              // Parallel
              > Proc "|" Proc [left]

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

// Makes it so we _don't_ shadow the variable referenced
syntax VarRef ::=
                "="     ProcId
              | "=" "*" NameId

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
                Bool
              | Int
              | String
              | Uri
              // The unforgeable processes used in the "new" process
              | "unforgeable(" Int ")"

// Collections
syntax Collection ::=
                RhoList
              | RhoTuple
              | RhoSet
              | RhoMap

syntax RhoList  ::= "[" Procs "]"
syntax RhoSet   ::= "Set" "(" Procs ")"
syntax RhoTuple ::=
              // Single tuple
                "(" Proc ",)"
              // Multiple tuple
              | "(" Proc "," Procs ")"

syntax RhoMap   ::= "{" RhoKeyValuePairs "}"

syntax RhoKeyValuePairs ::=
                RhoKeyValuePair
              | RhoKeyValuePair "," RhoKeyValuePairs

syntax RhoKeyValuePair  ::= Proc ":" Proc

// Expressions are anything that necessarily resolves to a single ground value or a collection
syntax Exp  ::=
                Ground
              // Collection
              | Collection
              // Arithmetic expressions
              | AExp


// Arithmetic expressions
syntax AExp ::=
              // Parens
                "(" AExp ")" [bracket]
              > Int "*"  Int [strict]
              | Int "/"  Int [strict]
              // Remainders
              | Int "%%" Int [strict]
              > Int "+"  Int [strict]
              | Int "-"  Int [strict]
              // Plus plus
              | Int "++" Int [strict]
              // Minus minus
              | Int "--" Int [strict]

// Booleans
syntax Bool ::=
              // Parens
                "(" Bool ")" [bracket]
              > Int "<"  Int
              | Int "<=" Int
              | Int ">"  Int
              | Int ">=" Int
              // Referencing processes
              > Proc "matches" Proc
              | Proc "==" Proc
              | Proc "!=" Proc
              | "not" Bool
              > Bool "and" Bool
              > Bool "or"  Bool

// Send
syntax Send  ::=
                SendSingle
              | SendMultiple

syntax SendSingle   ::=
              // Single send
                "!"  SendContent

syntax SendMultiple ::=
              // Persistent Send
                "!!" SendContent

syntax SendContent  ::=
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

// Branch
syntax Branch   ::= ReceiptLinear "=>" Proc
syntax Branches ::=
                Branch
              | Branch Branches

// Bundle
syntax Bundle ::=
              // Bundle write
                "bundle+"
              // Bundle read
              | "bundle-"
              // Bundle equiv
              | "bundle0"
              // Bundle read write
              | "bundle"

// Methods
syntax Method ::=
              // The list of current methods (add as more methods are defined)
                "method(nth)"
              | "method(toByteArray)"
              | "method(hexToBytes)"
              | "method(union)"
              | "method(diff)"
              | "method(add)"
              | "method(delete)"
              | "method(contains)"
              | "method(get)"
              | "method(getOrElse)"
              | "method(set)"
              | "method(keys)"
              | "method(size)"
              | "method(length)"
              | "method(slice)"
              // (Not yet in the interpreter)
              | "method(confine)"

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

// Name Declarations
syntax NameDeclaration  ::=
                NameVar
              | NameVar "(" Uri ")"

syntax NameDeclarations ::=
                NameDeclaration
              | NameDeclaration "," NameDeclarations
              | NameVars

syntax Uri ::= "uri(" String ")"

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
              // Collection pat
              | CollectionPat
              // Parallel
              | ProcPat "|" ProcPat [left]
              // Bracket
              | "{" ProcPat "}" [bracket]
              // logical negation
              > "~" ProcPat
              // logical "and"
              > ProcPat "/\\" ProcPat [left]
              // logical "or"
              > ProcPat "\\/" ProcPat [left]

syntax CollectionPat ::=
                RhoListPat
              | RhoSetPat

syntax RhoListPat ::=
                RhoList
              | "[" Procs "..." ProcVar "]"

syntax RhoSetPat ::=
                RhoSet
              | "Set" "(" Procs "..." ProcVar ")"

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
