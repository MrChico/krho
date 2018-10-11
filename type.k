module TYPE
imports RHO-SYNTAX

// Syntax for the type system.
syntax Type ::=
              // A function that rewrites to the type of the input
                "#type(" Type ")"
              // Initializing syntax
              | InitialType
              // Intermediate syntax
              | IntermediateType
              // Terminal syntax
              | TerminalType

// Recursive syntax for the type rewrites
syntax InitialType      ::= "type[" Pat "]" | "type[" Leaf "]"
syntax IntermediateType ::=
                            "type[" String ";;" InitialType      ";;" InitialType      "]" [strict(2,3)]
                          | "type[" String ";;" IntermediateType ";;" IntermediateType "]" [strict(3)]
                          | TerminalType

syntax TerminalType     ::=
                            "type[" String ";;" Leaf             ";;" Leaf             "]"
                          | "type[" String ";;" TerminalType     ";;" TerminalType     "]"

syntax Leaf             ::= Ground | Var | NameVar | ProcVar

// Syntax for strictness
syntax KResult ::= TerminalType

// Rewrite rules to generate types
rule type[ Chan:Name!(Msg:Proc) ] => type[ "send"  ;; type[Chan] ;; type[Msg] ]
rule type[ Chan:Name!!(Msg:Proc)] => type[ "psend" ;; type[Chan] ;; type[Msg] ]
rule type[ @P:Proc ]              => type[ "quote" ;; type["#@"] ;; type[P]   ]
rule type[ L:Leaf  ]              => type[ "leaf"  ;; "#leaf"    ;; L         ]

// Type( ) is strict, and rewrites as the type.
rule #type( T:TerminalType ) => T



// Type inclusion predicate
// The function #isIn is the inclusion predicate
syntax Bool ::= Type "#isIn" Type [function]


rule T1:Type #isIn T2:Type => true



endmodule
