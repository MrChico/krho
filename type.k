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

// *** Process types ***
// Ground terms
rule type[ I:Int                ] => [ "int"         ;; I ]
rule type[ S:String             ] => [ "string"      ;; S ]
rule type[ U:Uri                ] => [ "uri"         ;; U ]
rule type[ unforgeable( I:Int ) ] => [ "unforgeable" ;; I ]

// Boolean expressions
rule type[ true                    ] => type[ "bool"         ;; true     ]
rule type[ false                   ] => type[ "bool"         ;; false    ]
rule type[ not B:Bool              ] => type[ "boolnot"      ;; type[B]  ]
rule type[ I1:Int  <       I2:Int  ] => type[ "bool<"        ;; I1 ;; I2 ]
rule type[ I1:Int  >       I2:Int  ] => type[ "bool>"        ;; I1 ;; I2 ]
rule type[ I1:Int  <=      I2:Int  ] => type[ "bool<="       ;; I1 ;; I2 ]
rule type[ I1:Int  >=      I2:Int  ] => type[ "bool>="       ;; I1 ;; I2 ]
rule type[ P1:Proc matches P2:Proc ] => type[ "boolmatches"  ;; P1 ;; P2 ]
rule type[ P1:Proc ==      P2:Proc ] => type[ "bool=="       ;; P1 ;; P2 ]
rule type[ P1:Proc !=      P2:Proc ] => type[ "bool!="       ;; P1 ;; P2 ]
rule type[ B1:Bool and     B2:Bool ] => type[ "booland"      ;; type[B1] ;; type[B2] ]
rule type[ B1:Bool or      B2:Bool ] => type[ "boolor"       ;; type[B1] ;; type[B2] ]

// Collection
//   RhoList
rule type[ [ Hd:Proc Tl:Procs ] ] => [ "list" ;; type[ Hd ] ;; type[ [Tl] ] ]
rule type[ [ Sng:Proc         ] ] => [ "list" ;; type[Sng]                  ]

//   RhoTuple
rule type[ ( Hd:Proc Md:Proc Tl:Procs ) ] => [ "tuple" ;; type[Hd] ;; type[ (Md,Tl) ] ]
rule type[ ( Hd:Proc Tl:Proc          ) ] => [ "tuple" ;; type[Hd] ;; type[ ( Tl ,) ] ]
rule type[ ( Sng:Proc                ,) ] => [ "tuple" ;; type[Sng]                   ]

//   RhoSet
rule type[ Set( Hd:Proc Tl:Procs ) ] => [ "set" ;; type[Hd] ;; type[ Set(Tl) ] ]
rule type[ Set( Sng:Proc )         ] => [ "set" ;; type[Sng]                   ]

//   RhoMap
rule type[{ Hd:RhoKeyValuePair , Tl:RhoKeyValuePairs }] => [ "map" ;; type[ {Hd} ] ;; type[{Tl}] ]
rule type[{ Key:Proc : Val:Proc                      }] => [ "map" ;; type[Key]    ;; type[Val]  ]

// Process variables
rule type[ PV:ProcVar ] => type[ "procvar" ;; PV ]

// The empty process
rule type[ Nil ] => type[ "nil" ;; Nil ]

// Variable reference
rule type[ =  PV:ProcVar ] => type[ "varref" ;; type[PV] ]
rule type[ =* NV:NameVar ] => type[ "varref" ;; type[NV] ]

// Evaluate
rule type[ * N:Name ] => type[ "eval" ;; type[Name] ]

// Method
rule type[ P:Proc . M:Method ( PS:Procs ) ] => [ toString(M) ;; P ;; PS ]

// Arithmetic expressions
rule type[ I1:Int *  I2:Int ] => type[ "mult"       ;; I1 ;; I2 ]
rule type[ I1:Int /  I2:Int ] => type[ "div"        ;; I1 ;; I2 ]
rule type[ I1:Int %% I2:Int ] => type[ "mod"        ;; I1 ;; I2 ]
rule type[ I1:Int +  I2:Int ] => type[ "plus"       ;; I1 ;; I2 ]
rule type[ I1:Int -  I2:Int ] => type[ "minus"      ;; I1 ;; I2 ]
rule type[ I1:Int ++ I2:Int ] => type[ "plusplus"   ;; I1 ;; I2 ]
rule type[ I1:Int -- I2:Int ] => type[ "minusminus" ;; I1 ;; I2 ]


// Send
rule type[ Chan:Name!  Msg:Send ] => type[ "send"  ;; type[Chan] ;; type[Msg] ]
rule type[ Chan:Name!! Msg:Send ] => type[ "psend" ;; type[Chan] ;; type[Msg] ]

// Contract **needs to be given an alias which binds**
rule type[ contract Chan:Name ( Patns:NamePats ) = { Body:Proc } ] =>
             type[ "contract" ;; type[ "bind" ;; type[ Patns ] ;; type[ Body ] ] ;; type[ Chan ] ]
// Listen
rule type[ for( LB:LinearBinds   ){ Body:Proc } ] => type[ "listen"  ;; type[ LB ] ;; type[ Body ] ]
rule type[ for( RB:RepeatedBinds ){ Body:Proc } ] => type[ "plisten" ;; type[ RB ] ;; type[ Body ] ]

rule type[ Hd:LinearBind ; Tl:LinearBinds ] => type[ "linearbinds" ;; type[Hd]    ;; type[Tl]   ]
rule type[ Patns:NamePats <- Chan:Name  ]   => type[ "listen"      ;; type[Patns] ;; type[Name] ]
rule type[ Patns:NamePats <! Chan:Name  ]   => type[ "peek"        ;; type[Patns] ;; type[Name] ]

rule type[ Patns:NamePats <= Chan:Name ; RBs:RepeatedBinds ]
                  => type[ "repeatedbinds" ;; type[Patns <= Chan] ;; type[Rbs] ]
rule type[ Patns:NamePats <= Chan:Name ] => type[ "plisten" ;; type[Patns] ;; type[Chan] ]

// Name Patterns
rule type[ Hd:NamePat , Tl:NamePats ] => type[ "namepats" ;; type[Hd] ;; type[Tl] ]

// Match
rule type[ match P:Proc { MC:MatchCases } ] => type[ "match" ;; type[P] ;; type[MC] ]

rule type[ Hd:MatchCase Tl:MatchCases    ] => type[ "matchcases" ;; type[Hd]   ;; type[Tl]   ]
rule type[ Patn:ProcPat => { Body:Proc } ] => type[ "matchcase"  ;; type[Patn] ;; type[Body] ]

// Bundle
rule type[ bundle+ { P:Proc } ] => type[ "bundle+" ;; type[P] ]
rule type[ bundle- { P:Proc } ] => type[ "bundle-" ;; type[P] ]
rule type[ bundle0 { P:Proc } ] => type[ "bundle0" ;; type[P] ]
rule type[ bundle  { P:Proc } ] => type[ "bundle"  ;; type[P] ]

// If ... then ...
rule type[ if ( B:Bool ) P:Proc ] => type[ "if" ;; type[B] ;; type[P] ]

// If ... then ... else ...
rule type[ if ( B:Bool ) PTrue:Proc else PFalse:Proc ]
              => type[ "ifelse" ;; type[B] ;; type["ifelseprocs" ;; type[PTrue] ;; type[PFalse] ] ]

// New
rule type[ new N:NameDeclarations in { Body:Proc} ] => type[ "new" ;; type[N] ;; type[Body] ]

rule type[ Hd:NameDeclaration Tl:NameDeclarations ]
                              => type[ "namedeclarations" ;; type[Hd] ;; type[Tl] ]
rule type[ NV:NameVar ( U:Uri ) ] => type[ "urinamedeclaration" ;; type[NV] ;; type[U] ]

// Parallel
rule type[ P1:ProcPat | P2:ProcPat ] => type[ "par" ;; type[P1] ;; type[P2] ]

// *** Name types ***
rule type[ @P:Proc    ] => type[ "quote"   ;; type[P] ]
rule type[ NV:NameVar ] => type[ "namevar" ;; NV      ]

// *** Pattern types ***
// Collection pat
//   RhoListPat
rule type[ [Hd:Procs    ... Tl:ProcVar] ] => type[ "rholistpat" ;; type[Hd] ;; type[Tl] ]
//   RhoSetPat
rule type[ Set(Hd:Procs ... Tl:ProcVar) ] => type[ "rhosetpat"  ;; type[Hd] ;; type[Tl] ]

// SimpleType
rule type[ ST:SimpleType ] => type[ "simpletype" ;; toString(ST) ]

// logical negation
rule type[ ~ PPat:ProcPat ] => type[ "logicalnegate" ;; type[PPat] ]

// logical "and"
rule type[ PPat1:ProcPat /\ PPat2:ProcPat ] => type[ "logicaland" ;; PPat1 ;; PPat2]

// logical "or"
rule type[ PPat1:ProcPat \/ PPat2:ProcPat ] => type[ "logicalor"  ;; PPat1 ;; PPat2]



// Type( ) is strict, and rewrites as the type.
rule #type( T:TerminalType ) => T [strict]




// Type inclusion predicate
// The function #isIn is the inclusion predicate
syntax Bool ::= Type "#isIn" Type [function]



endmodule
