module INITIAL-CHECKS

// To include initial checks that need to be performed, including:

// 1. A check for free variables


// 2. A check for wildcards outside of patterns


// 2. A check for unforgeable names


// 3. Any normalization process that we want to do
//      ---> probably want to change variable names, because of examples like
//           for( @{{~{@{x}!(Nil)}}|x} <- @Nil ){ @{x}!("success") } | @Nil!(Nil|Nil)
//           where the first x isn't binding, but the second x is. (Those two x's should
//           be rewritten to different things -- the first being a dummy "variable".)



endmodule
