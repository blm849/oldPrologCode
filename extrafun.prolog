/* This prolog program provides extra functions that the prolog program
   ROSEBUD needs to perform. It also sets the pragmas for the ROSEBUD
   program.                                                             */
 
/* The following allow quicker debugging during development.            */
 
rb <- edconsult(rosebud).
break_point <- true.
<-break(break_point).
 
/* Set the pragmas.                                                     */
 
<- pragma(list,1).
<- pragma(long,1).
<- pragma(allgoal,1).
<- pragma(lcomment,1).
<- scan(*,10).
<- pragma(digit_is_char,1).
<- pragma(print_depth,10).
 
/* MEMBER/2 determines if ITEM is a member in LIST.                     */
 
member(ITEM,[ITEM!TAIL]).
member(ITEM,[HEAD!TAIL]) <- member(ITEM,TAIL).
 
 
/* APPEND/3 appends LIST1 to LIST2 to get LIST3.                        */
 
append([],LIST,LIST).
append(LIST, [], LIST).
append([HEAD1!TAIL1],LIST2,[HEAD1!TAIL3]) <-
        append(TAIL1,LIST2,TAIL3).
 
/* TOKENIZE/2 converts a character string STRING to a list LIST. The
   predicates TOKLIST, TOKEN, GET_WORD_CHARS, and LETTER_OR_DIGIT support
   TOKENIZE/2.                                                          */
 
tokenize(S,T) <- st_to_li(S,L) &  toklist(L,T,[]) .
 
toklist(L1,[Word!T],L3) <- token(L1,Word,L2) & / & toklist(L2,T,L3).
toklist(*,[],*).
 
token([" "!L1],Word,L2) <- / & token(L1,Word,L2) .
token([C!L1],Word,L2) <- letter_or_digit(C) & /
      &  get_word_chars(L1,Chars,L2)
      &  st_to_li(Strg,[C!Chars])
      &  st_to_at(Strg,Word).
token([C!L],C,L).
 
get_word_chars([C!L1],[C!Chars],L2) <- letter_or_digit(C) & /
      &  get_word_chars(L1,Chars,L2).
get_word_chars(L,[],L).
 
letter_or_digit(C) <- letter(C).
letter_or_digit(C) <- digit(C).
 
/* Access REXX functions to do such things as determine the date, etc.  */
 
<- ext_func(today(*), rexx_s, date).    /* Get today's date.            */
<- ext_func(the_time(*), rexx_s, time). /* Get the current time.        */
 
/* TODAY_O/1 tells you how far along in the week you are. E.G. If today
   is Monday, DayP is unified with 1, since Monday is the first day of
   of the week. TODAY_O means today's ordinal value.                    */
 
today_O(DayP) <-
          DayS := lower(today('W')) &
          st_to_at(DayS, DayA) &
          day_word([DayA],[],DayP).
 
/* This block of code is use by other rules to perform necessary
   conversions.                                                         */
 
/* ONE_STRING transforms a list of strings into one string.             */
 
one_string([],'').
one_string([Head ! Tail], New_str) <-
          one_string(Tail, Tail_str) &
          stconc(? Head || ' ', Tail_str, New_str).
 
/* MATCH_FIRST_ELEMENT/3 tries to find S_ATOM in its second argument
   (a list). Its third argument is unified with every item in the
   list which follows the occurence of S_ATOM.                          */
 
match_first_element(S_atom, [S_atom ! S1], S1).
 
match_first_element(S_atom, [S0 ! S1], S2) <-
    match_first_element(S_atom, S1, S2).
 
match_first_element([],[],[]).
 
/* MATCH_THE_REST/2 tries to match the atoms which belong to the list
 in its first argument with the atoms which belong to the list in the
 second argument.                                                       */
 
match_the_rest([S0 ! S1], [S0 ! L1]) <-
   match_the_rest(S1, L1).
 
match_the_rest([],S).
 
/* SUBLIST/2 tries to determine if the first argument (which is a list)
   can be found in the second argument (which is also a list). It does
   this by first trying to find an element both lists have in common.
   If one is found, it then tries to match every other element in the
   first list with every one in the second list.                        */
 
sublist([S0 ! S1], L) <-
   match_first_element(S0, L, L1) &
   match_the_rest(S1, L1).
 
sublist([S0 ! nil], L) <-
   match_first_element(S0, L, L1).
 
sublist([],S).
 
 
/* FORMAT_TIME converts seconds into a digital format.
   e.g. <-format_time(62,'00:01:02') succeeds.                          */
 
format_time(Seconds, Digital) <-
       HH := Seconds / 3600 &
       MM := (Seconds - (HH * 3600)) / 60 &
       SS := rem(Seconds, 60) &
       Digital := substring(? '00' || HH, ? len(string(HH))) || ':' ||
       substring(? '00' || MM, ? len(string(MM))) || ':' ||
       substring(? '00' || SS, ? len(string(SS))).
 
/* TIMECALC/5 takes the current day and time and adds the amount in
   TimeIncrease to determine the new day and time. Note: OldDay and
   NewDay are both in units of seconds. OldDay and NewDay have values
   between 1 and 7, where 1 stands for Monday and 7 stands for Sunday.  */
 
timecalc(OldDay, OldTime, TimeIncrease, NewDay, NewTime) <-
   ge(?OldTime + TimeIncrease, 86400) &
   gt(?OldDay + 1, 7) &
   NewTime := (OldTime + TimeIncrease - 86400) &
   NewDay  := (OldDay  - 6).
 
timecalc(OldDay, OldTime, TimeIncrease, NewDay, NewTime) <-
   ge(?OldTime + TimeIncrease, 86400) &
   le(?OldDay + 1, 7) &
   NewTime := (OldTime + TimeIncrease - 86400) &
   NewDay  := (OldDay  + 1).
 
timecalc(OldDay, OldTime, TimeIncrease, NewDay, NewTime) <-
   lt(?OldTime + TimeIncrease, 86400) &
   gt(?OldDay + 1, 7) &
   NewTime := (OldTime + TimeIncrease) &
   NewDay  := (OldDay  - 6).
 
timecalc(OldDay, OldTime, TimeIncrease, NewDay, NewTime) <-
   lt(?OldTime + TimeIncrease, 86400) &
   le(?OldDay + 1, 7) &
   NewTime := (OldTime + TimeIncrease) &
   NewDay  := (OldDay  + 1).
 
/* TIMECOMP/5 takes the first day and time, compares it to the second
   day and time, and stores either 'BEFORE', 'AFTER', or 'EQUAL' in
   Result. What value Result gets depends in whether the first day and
   time is before, after or equal to the second day and time.
   N.B. If the first day is 7 and the second day is 1, then it is assumed
   that the first day is before the second. Normally, if the first day is
   greater than the second day, then it is assumed to be AFTER the
   second day.                                                          */
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   eq(Day1, Day2) & eq(Time1, Time2) & Result := 'EQUAL'.
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   eq(Day1, 7) & eq(Day2, 1) & Result := 'BEFORE'.
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   gt(Day1, Day2) & Result := 'AFTER'.
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   lt(Day1, Day2) & Result := 'BEFORE'.
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   eq(Day1, Day2) & gt(Time1, Time2) & Result := 'AFTER'.
 
timecomp(Day1, Time1, Day2, Time2, Result) <-
   eq(Day1, Day2) & lt(Time1, Time2) & Result := 'BEFORE'.
 
/* PHONE takes a list and converts it into a string which
   equals someone's phone number. Any non-numeric characters in the list
   are ignored. The result is a string containing only the digits which
   make up the person's phone number.                                   */
 
phone([],'') <- /.              /* Null lists results in a null string. */
 
/* If the first element of the list is an integer, convert it to a string
   and concatenated it to the string version of all the other numbers
   remaining in the list.      */
 
phone([Head ! Tail], PhoneNumber) <-
    is_int(Head) &
    st_to_nb(Headstr, Head) &
    phone(Tail, Tailstr) &
    stconc(Headstr, Tailstr, PhoneNumber) & /.
 
/* If the first element in the list is NOT an integer, then skip it and
    go to the next element in the list.     */
 
phone([Head ! Tail], PhoneNumber) <-
     ¬is_int(Head) &
     phone(Tail, PhoneNumber) & /.
 
/* EXTRACT_TIME_RANGE/2 and WITHIN_TIME_RANGE/6 are used by IS_ONCALL/3
   to determine whether or not a person is on call.                     */
 
extract_time_range([Sd0,St0,Ed0,Et0], [Sd0,St0,Ed0,Et0]).
extract_time_range([Sd0,St0,Ed0,Et0], [Sd0,St0,Ed0,Et0 ! Rest_of_the_list]).
extract_time_range([Sd0,St0,Ed0,Et0], [Sd1,St1,Ed1,Et1 ! Rest_of_the_list]) <-
                 extract_time_range([StartDay1,St1,Ed1,Et1], Rest_of_the_list).
 
within_time_range(Day, Time, StartDay, StartTime, EndDay, EndTime) <-
                gt(StartDay, EndDay) &
                (lt(StartDay, Day) |
                 eq(StartDay, Day) & le(StartTime, Time)) &
                (lt(Day, 7) |
                 eq(Day, 7) & le(Time, 86400)).
 
within_time_range(Day, Time, StartDay, StartTime, EndDay, EndTime) <-
                gt(StartDay, EndDay) &
                (lt(1, Day) |
                 eq(1, Day) & le(0, Time)) &
                (lt(Day, EndDay) |
                 eq(Day, EndDay) & le(Time, EndTime)).
 
within_time_range(Day, Time, StartDay, StartTime, EndDay, EndTime) <-
                le(StartDay, EndDay) &
                (lt(StartDay, Day) |
                 eq(StartDay, Day) & le(StartTime, Time)) &
                (lt(Day, EndDay) |
                 eq(Day, EndDay) & le(Time, EndTime)).
 
