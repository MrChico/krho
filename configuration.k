
module CONFIGURATION
imports RHO-SYNTAX

// Configuration
configuration <T color="yellow">
                // Any non send/receive computations go here
                <Thread multiplicity="*">
                  <k color="red"> $PGM:Proc </k>
                </Thread>
                // The tuple space
                <In multiplicity="*">
                  // computations of auxiliary functions
                  // happen in the auxiliary cells
                  // Auxiliary functions may nest, so
                  // we give a nonzero multiplicity
                  <Aux multiplicity="*"> .K </Aux>
                </In>
                <Out multiplicity="*">
                  <Aux multiplicity="*"> .K </Aux>
                </Out>
              </T>

endmodule
