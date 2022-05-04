/* This prolog program provides a list of words and phrases that the prolog
   program ROSEBUD will be analyzing.                                   */
 
/* The phrases in alphabetical order are...                             */
 
access_data_phrase([access, data ! S], S).
alive_and_well_phrase([rosebud,is, alive, and, well ! S], S).
backup_phrase([B, backs, up, A, after ! S], [A, B ! S]).
carried_phrase([A, is, carried, by ! B], [A ! B]).
clist_phrase([logon, clist, has, completed ! S], S).
dialout_phrase([dialout, number ! B], B).
initial_command_phrase([initial, command ! S], S).
logged_on_phrase([rosebud, logged, on ! S], S).
page_phrase([P, page ! S], [P ! S]).
page_phrase([P, pages ! S], [P ! S]).
remote_support_phrase([remote, support ! S], S).
service_phrase([service, Service, ":" ! S],  [Service ! S]).
session_id_phrase([session, identifier, id ! S], S).
superior_phrase([B, supervises, A, after ! S], [A, B ! S]).
synchronization_phrase([it, is, now, MO,"-",DD,"-",YY,",",HH,":",MI,":",SS ! S],
                       ? MO || '-' || DD || '-' || YY,
                       ? HH || ':' || MI || ':' || SS, S).
time_period_phrase([Hours, hrs ! S], S, ? Hours * 3600).
time_period_phrase([Minutes, min ! S], S, ? Minutes * 60).
time_period_phrase([TotalSeconds, sec ! S], S, TotalSeconds).
 
/* The words in alphabetical order are...                               */
 
a_system_word(A,A).
any_word([A ! S], S, A).
comment_word(["*" ! S], S).
comment_word(["C" ! S], S).
comment_word(["E" ! S], S).
day_word([monday ! S], S, 1).
day_word([tuesday ! S], S, 2).
day_word([wednesday ! S], S, 3).
day_word([thursday ! S], S, 4).
day_word([friday ! S], S, 5).
day_word([saturday ! S], S, 6).
day_word([sunday ! S], S, 7).
discard_word([discard, PagerNumber ! S], [PagerNumber, S]).
exception_word([exceptions ! S], S).
for_word([for ! S], S).
from_word([from ! B], B).
hold_word([hold, PagerNumber ! S], [PagerNumber, S]).
invalid_tag_word([<, S1, > ! S2], S1).
logon_word([logon ! S], S).
netview_word([netview ! S], S).
number_word([number ! S], S).
number_word([numbers ! S], S).
oncall_word([oncall ! S], S).
page_word([pages ! S], S).
page_word([paging ! S], S).
pager_word([pager ! S], S).
pager_word([pager, PagerNumber ! S], S, PagerNumber).
pass_word([pass ! S], S).
reason_word([reasoning ! S], S).
rosebud_word([rsbd ! S], S).
rosebud_word([<, rsbd , > ! S], S).
send_word([send ! S], S).
send_word([sending ! S], S).
start_word([start ! S], S).
stop_word([stop ! S], S).
tag_word([Tag ! S], [Tag ! S]) <- term_get(tag, Tag, *).
tag_word([<, Tag, > ! S], [Tag ! S]) <- term_get(tag, Tag, *).
tag_word([<,error,> ! S], S).
tag_word([<,heart , _, beat , > ! S], S).
tag_word([<,heartbeat, > ! S], S).
system_word([A ! S], S).
text_word([text ! S], S).
time_word([HH, ":", MM, ":", SS ! S], S).
time_word([HH, ":", MM, ":", SS ! S], S, TotalSeconds) <-
         is_int(HH) & is_int(MM) & is_int(SS) &
         TotalSeconds := 3600 * HH + 60 * MM + SS.
time_word([HH, ":", MM ! S], S).
time_word([HH, ":", MM ! S], S, TotalSeconds) <-
         is_int(HH) & is_int(MM) &
         TotalSeconds := 3600 * HH + 60 * MM.
to_word([to ! S], S).
until_word([until ! S], S).
 
/* Other phrase-like facts.                                             */
 
anything(S,S).
anything([A, B ! S]) <- anything(B,S).
colon([":" ! S], S).
quote(["""" ! S], S).
 
