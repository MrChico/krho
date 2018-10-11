module PATTERN-MATCH
imports TYPE

// Matching Function
syntax Match ::=
              // Matching processes
                "#patternMatch" Proc "#via" ProcPat "#in" Proc
              // Matching names
              | "#patternMatch" Name "#via" NamePat "#in" Proc

// Matching by using types and the type inclusion predicate
// if multiple match cases
rule match P:Proc { P1:ProcPat => { P2:Proc } M:MatchCases }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  match P:Proc { M:MatchCases }
     #fi

// if a single match case
rule match P:Proc { P1:ProcPat => { P2:Proc } }
  => #if    #type( type[ P ] ) #isIn #type( type[ P1 ] )
     #then  #patternMatch P #via P1 #in P2
     #else  Nil
     #fi

// Temporary
rule #patternMatch P:Proc #via P1:ProcPat #in P2:Proc => "success"

endmodule
