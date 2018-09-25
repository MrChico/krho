
module CONFIGURATION
imports RHO-SYNTAX

// Configuration
configuration <T color="yellow">
                // Concurrent threads for processes to run
                <thread multiplicity="*">
                  <k color="red"> $PGM:Proc </k>
                </thread>
                // The tuple space
                <In multiplicity="*">
                  <chan>  .K  </chan>  // list of names
                  <guard> .K  </guard> // list of patterns
                  <body>  .K  </body>
                  // Bool to determine whether or not is persistent
                  <persistent> .K </persistent>
                </In>
                <Out multiplicity="*">
                  <chan>  .K  </chan>  // list of names 
                  <msg>   .K  </msg>
                  // Bool to determine whether or not is persistent
                  <persistent> .K </persistent>
                </Out>
              </T>

endmodule
