// My own interpretation of the semantics of rholang. Heavily inspired by Dereks work at https://github.com/rchain/rchain/tree/master/rholang/src/main/k/rholang
require "rho-syntax.k"

module RHO
imports RHO-SYNTAX

// Configuration
configuration
        <T color="yellow">
           <k color="red"> $PGM:Proc </k>
           <Ins>
              <In multiplicity="*" color="purple"> . </In>                  
           </Ins>
           <Outs>
              <Out multiplicity="*" color="purple"> . </Out>
           </Outs>   
           <comm-count> 0 </comm-count>
        </T>

endmodule
