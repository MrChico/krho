# Process pseudocode to help build the configuration
This doc is just meant to contain high-level ideas about the flow of computation in order to
effectively reason about and build a good configuration. The main ideas pertaining to each process
should be included in one of these sections.


## Sending
A thread is spawned of the form

    <thread>
      <k> Name Send </k>
    </thread>

Before committing the send to the tuple space, we check the tuple space for:
1. Listens on a channel equivalent to `Name`
    - If there is some standard form of names, then we can use K's matcher to find these. If not, it
    seems to me that we'll have to check the entire tuple space exhaustively. There may be some way
    to normalize names such that the check doesn't have to be totally exhaustive.
2. If there is such a listen, check to see if the `msg` in `Send` matches the pattern in the
listen's `<guard>` cell.
3. If there is a match, make appropriate substitutions, consume either the send's thread or the
listen's entry in the tuple space (or both) if appropriate, and spawn a new thread with the body of
the listen in the `<k>` cell.

### Persistent sending
If the send is persistent, check for matches and then commit it to the tuple space permanently.


### Pseudocode
Any given check for matching might start with a configuration like:

    ...
    <thread>
      <k> Name1 Send </k>
    </thread>
    <In>
      ...
      <inbound> Name2 </inbound>
      <guard>   Pat   </guard>
      <body>    Body  </body>
      ...
    </In>
    ...

And then go something along the lines of:

    if ( AreNameEquivalent( Name1, Name2 ) )
    {
      if ( DoesMsgPassGuard( Msg , Pat ) )
      {
        PerformSubstitutions( Msg , Pat );
        SpawnNewThread( BodyAfterSubstitution );
      }
    }

Here `Msg` is the process sent and forms part of the `Send`.

## Listening (not joined)
A thread is spawned of the form

    <thread>
      <k> for( Receipt ){ Body } </k>
    </thread>

where `Receipt` is either of the form `Pattern <- Name` or `Pattern <= Name`.

Before committing the listen to the tuple space, we check the tuple space for:
1. Sends on a channel equivalent to `Name`
    - Same stipulation on `Name`s as mentioned in the section on sends.
2. If there is such a send, check to see if the `msg` in send's `<msg>` cell matches `Pattern`.
3. If there is a match, make appropriate substitutions, consume either the listen's thread or the
send's entry in the tuple space (or both) if appropriate, and spawn a new thread with the body of
the listen in the `<k>` cell.

### Persistent listening
If the listen is persistent, check for matches and then commit it to the tuple space permanently.


### Pseudocode
Any given check for matching might start with a configuration like:

    ...
    <thread>
      <k> for( Receive ){ Body } </k>
    </thread>
    <Out>
      ...
      <outbound> Name2 </outbound>
      <msg>      Msg   </msg>
      ...
    </Out>
    ...

where `Receive` is of the form `Pattern <- Name1` or `Pattern <= Name1`, and then go something along
the lines of:

    if ( AreNameEquivalent( Name2, Name1 ) )
    {
      if ( DoesMsgPassGuard( Msg , Pat ) )
      {
        PerformSubstitutions( Msg , Pat );
        SpawnNewThread( BodyAfterSubstitution );
      }
    }

Note this last bit of pseudocode is identical to that for the sends.


## Listens with nontrivial joins
Using the same notation as before, we might end up with a configuration of

    ...
    <thread>
      <k> for( Receive ){ Body } </k>
    </thread>
    // The tuple space
    // In cells to check
    ...

where `Receive` is either of the form
  - `Pattern1 <- Name_1 ; ... ; Pattern_N <- NameN`, or
  - `Pattern1 <= Name_1 ; ... ; Pattern_N <= NameN`

The matching might go along the lines of:

    Find N Sends on channels Name^i and with messages Msg^i
    if ( AreNameEquivalent( Name^1, Name_1 ; ... ; Name^N, Name_N ) )
    {
      if ( DoesMsgPassGuard( Msg^1 , Pattern_1 ; ... ; Msg^N , Pattern_N ) )
      {
        PerformSubstitutions( Msg^1 , Pattern_1 ; ... ; Msg^N , Pattern_N );
        SpawnNewThread( BodyAfterSubstitution );
      }
      else
      {
        Find a different combination of N Sends, or commit to tuple space if there are no others.
      }
    }
    else
    {
      Find a different combination of N Sends, or commit to tuple space if there are no others.
    }

__It is unclear to me how to deal with nontrivial joins in the tuple space.__
