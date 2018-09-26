
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
                  <mailfrom> .K  </mailfrom> // list of names
                  <guard>    .K  </guard> // list of patterns
                  <body>     .K  </body>
                  // Bool to determine whether or not is persistent
                  <linear>   .K  </linear>
                </In>
                <Out multiplicity="*">
                  <mailto>   .K  </mailto>  // list of names
                  <msg>      .K  </msg>
                  // Bool to determine whether or not is persistent
                  <single>   .K  </single>
                </Out>
              </T>

endmodule
